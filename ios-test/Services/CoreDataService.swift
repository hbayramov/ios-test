//
//  CoreDataService.swift
//  ios-test
//
//  Created by Huseyn Bayramov on 7/19/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataServiceProtocol {
    var context: NSManagedObjectContext { get }
    var persistenceContainer: NSPersistentContainer { get }
    func saveOrUpdate(categories data: [Category], completion: @escaping (ErrorCode?) -> Void)
    func fetchCategories(completion: @escaping (Result<[Category], ErrorCode>) -> Void)
    func hasCategory(id: String) -> CCategory?
    func batchDelete() throws
}

class CoreDataService: CoreDataServiceProtocol {
    var context: NSManagedObjectContext
    var persistenceContainer: NSPersistentContainer
    
    init(_ context: NSManagedObjectContext = CoreDataContext.shared.viewContext,
         persistenceContainer: NSPersistentContainer = CoreDataContext.shared.persistentContainer) {
        self.context = context
        self.persistenceContainer = persistenceContainer
    }
    
    func saveOrUpdate(categories data: [Category], completion: @escaping (ErrorCode?) -> Void) {
        if data.isEmpty { completion(.none) }
    
        for category in data {
            do {
                var cCategory = hasCategory(id: category.id ?? "")
                
                if cCategory == nil {
                    cCategory = CCategory(context: context)
                }
                
                cCategory?.name = category.name
                cCategory?.id = category.id
                
                cCategory?.provider = nil
                for provider in category.providers ?? [] {
                    let cProvider = CProvider(context: context)
                    cProvider.name = provider.name
                    cProvider.id = provider.id
                    
                    for field in provider.fields ?? [] {
                        let cField = CField(context: context)
                        cField.id = field.id
                        cField.label = field.label
                        cField.type = Int64(field.type?.rawValue ?? 0)
                        
                        for option in field.options ?? [] {
                            let cPair = CPair(context: context)
                            cPair.k = option.k
                            cPair.v = option.v
                            cField.addToPair(cPair)
                        }
                        cProvider.addToField(cField)
                    }
                    cCategory?.addToProvider(cProvider)
                }
                try context.save()
            } catch {
                completion(.unknownError)
            }
        }
        completion(.none)
    }
    
    func fetchCategories(completion: @escaping (Result<[Category], ErrorCode>) -> Void) {
        
        let fetchRequest: NSFetchRequest<CCategory> = CCategory.fetchRequest()
        
        do {
            let fetchedData = try context.fetch(fetchRequest)
            
            var categories = [Category]()
            
            for data in fetchedData {
                var category = Category(id: data.id, name: data.name, providers: [Provider]())
                
                for dProv in data.provider?.allObjects as! [CProvider] {
                    var provider = Provider(id: dProv.id, name: dProv.name, fields: [Field]())
                    
                    for dField in dProv.field?.allObjects as! [CField] {
                        var field = Field(id: dField.id, type: FieldType(rawValue: Int(dField.type)), label: dField.label, options: [Pair]())
                        
                        for dOpt in dField.pair?.allObjects as! [CPair] {
                            let option = Pair(k: dOpt.k, v: dOpt.v)
                            field.options?.append(option)
                        }
                        provider.fields?.append(field)
                    }
                    category.providers?.append(provider)
                }
                categories.append(category)
            }
            
            completion(.success(categories))
        } catch {
            completion(.failure(.noData("")))
        }
        
    }
    
    func hasCategory(id: String) -> CCategory? {
        let fetchRequest: NSFetchRequest<CCategory> = CCategory.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        
        var results: [NSManagedObject] = []
        
        do {
            results = try context.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return results.first as? CCategory
    }
    
    func batchDelete() throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CCategory.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
        } catch {
            throw ErrorCode.unknownError
        }
    }
    
}

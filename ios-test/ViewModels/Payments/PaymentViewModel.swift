//
//  PaymentViewModel.swift
//  ios-test
//
//  Created by Huseyn Bayramov on 7/18/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import CoreData

class PaymentViewModel: BaseViewModel {
    private let context: NSManagedObjectContext = CoreDataContext.shared.viewContext
    private let coreDataService = CoreDataService()
    
    var categoryData: [Category]?
    var categoryCellData = [CategoryCellModel]()
    var selectedCategory: Category?
    var selectedProvider: Provider?
    var selectedFields = [Pair]()
    var receipt: Receipt?
    
    var fields: [Field]? {
        if let fields = selectedProvider?.fields {
            return fields
        }
        return nil
    }
    
    var paymentRequest = PaymentRequest()
    
    private lazy var fetchedResultController: NSFetchedResultsController<CCategory> = {
        let fetchRequest: NSFetchRequest<CCategory> = CCategory.fetchRequest()
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }()
    
    func getCateogries(completion: @escaping ErrorCodeType) {
        if !Reachability.isConnectedToNetwork() {
            completion(.notConnectedToInternet)
            return
        }
        
        endpoint.getCategories { [weak self] result in
            switch result {
            case .success(let resultData):
                
                guard let data = resultData?.data else {
                    if let error = resultData?.error {
                        switch error.code {
                        case .parameterMissing:
                            completion(.parameterMissing(error.message ?? ""))
                            return
                        case .serviceUnavailable:
                            completion(.serviceUnavailable(error.message ?? ""))
                            return
                        default:
                            return
                        }
                    }
                    
                    completion(.noData(""))
                    return
                }
                
                self?.categoryData = data
                self?.saveOnDatabase()
                self?.addCategoryCellData()
                completion(nil)
                
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func makePayment(completion: @escaping ErrorCodeType) {
        if !Reachability.isConnectedToNetwork() {
            completion(.notConnectedToInternet)
            return
        }
        
        let body = onJsonBody(data: paymentRequest)
        print("make new payment body ", body)
        endpoint.makeNewPayment(body: body) { [weak self] result in
            switch result {
            case .success(let resultData):
                guard let data = resultData?.data else {
                    if let error = resultData?.error {
                        switch error.code {
                        case .parameterMissing:
                            completion(.parameterMissing(error.message ?? ""))
                            return
                        case .serviceUnavailable:
                            completion(.serviceUnavailable(error.message ?? ""))
                            return
                        default:
                            return
                        }
                    }
                    
                    completion(.noData("No data found"))
                    return
                }
                
                self?.receipt = data
                completion(nil)
                
            case .failure(let error):
                completion(error)
            }
        }
    }
}

//MARK: Methods
extension PaymentViewModel {    
    func addCategoryCellData() {
        guard let categories = categoryData else { return }
        
        categoryCellData = []
        for cat in categories {
            categoryCellData.append(CategoryCellModel(id: cat.id, name: cat.name))
        }
    }
    
    private func saveOnDatabase() {
        guard let categories = categoryData else { return }
        
        coreDataService.saveOrUpdate(categories: categories) { error in
            if let err = error {
                print("error when save on db \(err)")
            } else {
                print("successfully saved")
            }
        }
    }
    
    func fetchCategoriesFromDb(completion: @escaping (Bool) -> ()) {
        coreDataService.fetchCategories { [weak self] result in
            do {
                let categories = try result.get()
                if categories.count > 0 {
                    self?.categoryData = categories
                    self?.addCategoryCellData()
                    completion(true)
                }
            } catch {
                print("error \(error)")
                completion(false)
            }
        }
    }
    
    func batchDelete() {
        do {
            try coreDataService.batchDelete()
        } catch {
            print("error on batch delete \(error)")
        }
    }
    
    func getCountByTag(tag: String) -> Int {
        return (fields?.filter({ $0.id == tag }).first?.options?.count ?? 0)
    }
    
    func getValueByTag(tag: String, row: Int) -> String {
        let opt = fields?.filter({ $0.id == tag }).first?.options
        return opt?[row].v ?? ""
    }
    
    func addToSelectedField(id: String, row: Int, value: String = "") {
        guard let field = fields?.first(where: { $0.id == id }) else { return }
        let index = selectedFields.firstIndex(where: { $0.k == id })
        var pair: Pair?
        
        guard let type = field.type else { return }
        
        if type == .selectBox {
            if let ind = index {
                selectedFields[ind].v = field.options?[row].v
            } else {
                pair = Pair(k: String(id), v: field.options?[row].v)
            }
        } else {
            if let ind = index {
                selectedFields[ind].v = value
            } else {
                pair = Pair(k: String(id), v: value)
            }
        }
        
        if let pr = pair {
            selectedFields.append(pr)
        }
    }
    
    func isSelectedEmpty(tag: String) -> Bool {
        return !selectedFields.contains(where: { $0.k == tag })
    }
}

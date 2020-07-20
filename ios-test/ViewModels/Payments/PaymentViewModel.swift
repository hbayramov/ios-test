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
                self?.addCategoryCellData()
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
}

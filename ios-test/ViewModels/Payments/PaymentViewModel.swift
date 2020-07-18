//
//  PaymentViewModel.swift
//  ios-test
//
//  Created by Huseyn Bayramov on 7/18/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

class PaymentViewModel: BaseViewModel {
    var categoryData: [Category]?
    var categoryCellModels = [CategoryCellModel]()
    
    func getCateogries(completion: @escaping ErrorCodeType) {
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
        
        categoryCellModels = []
        for cat in categories {
            categoryCellModels.append(CategoryCellModel(id: cat.id, name: cat.name))
        }
    }
}

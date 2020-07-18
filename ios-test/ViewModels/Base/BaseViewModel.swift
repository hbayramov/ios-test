//
//  BaseViewModel.swift
//  ios-test
//
//  Created by Huseyn Bayramov on 7/18/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

class BaseViewModel {
    let endpoint = Endpoints.shared
    typealias ErrorCodeType = (ErrorCode?) -> ()
    
    func onJsonBody<T: Encodable>(data: T) -> String {
        if let body = try? JSONEncoder().encode(data) {
            return String(data: body, encoding: .utf8) ?? ""
        }
        return ""
    }
}

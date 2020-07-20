//
//  ErrorService.swift
//  ios-test
//
//  Created by Huseyn Bayramov on 7/18/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct ErrorService: Error {
    
    private init() {}
    
    // Handle error codes and return localized description
    static func handle(error err: ErrorCode) -> String {
        switch err {
        case .noData(let error):
            return error
        case .parsingError:
            return "No data found"
        case .responseError(let errorString):
            return errorString
        case .fieldError(let errorString):
            return errorString
        case .unknownError:
            return "Unknown Error occurred"
        case .notConnectedToInternet:
            return "Not connected to Internet"
        case .parameterMissing(_):
            return "Parameter missing"
        case .serviceUnavailable(_):
            return "Service temporarily unavailable"
        }
    }
    
}

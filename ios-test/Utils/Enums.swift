//
//  Enums.swift
//  ios-test
//
//  Created by Huseyn Bayramov on 7/18/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

enum ErrorCode: Error, Equatable {
    case noData(String)
    case parsingError
    case responseError(String)
    case unknownError
    case notConnectedToInternet
    case fieldError(String)
    case parameterMissing(String)
    case serviceUnavailable(String)
}

enum AppResponse<T> {
    case success(T?)
    case failure(ErrorCode)
}

enum ResponseErrorCode: Int, Codable {
    case serviceUnavailable = 1
    case parameterMissing = 2
}

enum FieldType: Int, Codable {
    case textField = 1
    case numberic = 2
    case float = 3
    case selectBox = 4
    case date = 5
}

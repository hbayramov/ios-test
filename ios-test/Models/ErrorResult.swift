//
//  Error.swift
//  ios-test
//
//  Created by Huseyn Bayramov on 7/18/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct ErrorResult: Decodable {
    var code: ResponseErrorCode?
    var message: String?
}

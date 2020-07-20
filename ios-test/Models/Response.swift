//
//  Response.swift
//  ios-test
//
//  Created by Huseyn Bayramov on 7/18/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct Response<T: Decodable>: Decodable {
    var error: ErrorResult?
    var data: T?
}

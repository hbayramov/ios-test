//
//  Pair.swift
//  ios-test
//
//  Created by Huseyn Bayramov on 7/18/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct Pair<T: Decodable>: Decodable {
    var k: T?
    var v: T?
}

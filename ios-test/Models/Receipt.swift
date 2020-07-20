//
//  Receipt.swift
//  ios-test
//
//  Created by Huseyn Bayramov on 7/18/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct Receipt: Decodable {
    var id: String?
    var date: String?
    var details: [Pair]?
    var amount: Amount?
}

//
//  PaymentRequest.swift
//  ios-test
//
//  Created by Huseyn Bayramov on 7/21/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct PaymentRequest: Encodable {
    var providerId: String?
    var fields: [Pair]?
    var amount: Amount?
    var card: Card?
}

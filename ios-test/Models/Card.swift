//
//  Card.swift
//  ios-test
//
//  Created by Huseyn Bayramov on 7/21/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct Card: Encodable {
    var number: String?
    var expMonth: String?
    var expYear: String?
    var cvv: String?
    
    enum CodingKeys: String, CodingKey {
        case number
        case expMonth = "exp_month"
        case expYear = "exp_year"
        case cvv
    }
}

//
//  Provider.swift
//  ios-test
//
//  Created by Huseyn Bayramov on 7/18/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct Provider: Decodable {
    var id: String?
    var name: String?
    var fields: [Field]?
}

//
//  Fields.swift
//  ios-test
//
//  Created by Huseyn Bayramov on 7/18/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct Field: Decodable {
    var id: String?
    var type: FieldType?
    var label: String?
    var options: [Pair<String>]?
}

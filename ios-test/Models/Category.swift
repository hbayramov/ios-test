//
//  Category.swift
//  ios-test
//
//  Created by Huseyn Bayramov on 7/18/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct Category: Decodable {
    var id: String?
    var name: String?
    var providers: [Provider]?
}

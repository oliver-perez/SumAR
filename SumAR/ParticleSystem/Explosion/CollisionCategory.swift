//
//  CollisionCategory.swift
//  SumAR
//
//  Created by Álvaro Ávalos Hernández on 1/23/19.
//  Copyright © 2019 OliverPérez. All rights reserved.
//

import Foundation

struct CollisionCategory: OptionSet {
    let rawValue: Int
    static let airplaneCategory  = CollisionCategory(rawValue: 1 << 0)
    static let ringCategory = CollisionCategory(rawValue: 1 << 1)
}

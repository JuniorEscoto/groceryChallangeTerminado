//
//  ArrayExtension.swift
//  Grocery Challenge
//
//  Created by Aylwing Olivas on 8/16/18.
//  Copyright © 2018 Instacart. All rights reserved.
//

import Foundation

extension Array {
    mutating func shuffle() {
        forEach { _ in
            sort { _,_ in arc4random() < arc4random() }
        }
    }
}

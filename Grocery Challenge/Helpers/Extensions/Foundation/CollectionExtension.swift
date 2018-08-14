//
//  CollectionExtension.swift
//  Grocery Challenge
//
//  Created by Aylwing Olivas on 8/16/18.
//  Copyright © 2018 Instacart. All rights reserved.
//

import Foundation

extension Collection {

    /// Returns a random element in the collection with it's index or nil if the collection is empty.
    var randomElement: (element: Element, index: Index)? {
        guard !isEmpty else { return nil }
        let randomIndex = Int(arc4random_uniform(UInt32(self.count)))
        let calculatedIndex = self.index(self.startIndex, offsetBy: randomIndex)
        return (self[calculatedIndex], calculatedIndex)
    }
}

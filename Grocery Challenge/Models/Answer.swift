//
//  Answer.swift
//  Grocery Challenge
//
//  Created by Aylwing Olivas on 8/16/18.
//  Copyright © 2018 Instacart. All rights reserved.
//

import Foundation

struct Answer: Codable {
    let url: URL // A URL pointing to a remote image
    let correct: Bool // Is this the correct answer or not
}

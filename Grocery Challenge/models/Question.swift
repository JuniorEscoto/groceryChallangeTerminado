//
//  Question.swift
//  Grocery Challenge
//
//  Created by Andrew Crookston on 5/14/18.
//  Copyright © 2018 Instacart. All rights reserved.
//

import Foundation

struct Answer: Codable {
    let url: URL
    let correct: Bool
}

struct Question: Codable {
    let query: String
    let answers: [Answer]
}

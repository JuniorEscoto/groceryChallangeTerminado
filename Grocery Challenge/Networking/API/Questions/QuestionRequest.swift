//
//  QuestionRequest.swift
//  Grocery Challenge
//
//  Created by Aylwing Olivas on 8/16/18.
//  Copyright © 2018 Instacart. All rights reserved.
//

import Foundation

struct QuestionsRequest: Requests {

    let url: URL

    private static let defaultURL = URL(string:
        "https://gist.github.com/acrookston/e1af7bf2e2607db3d27a0b44ed1843c1/raw/490d746e54e774476652cf8ab65f9c912e54e95f/question.json"
    )

    init(url: URL! = defaultURL) {
        self.url = url
    }
}

//
//  APIError.swift
//  Grocery Challenge
//
//  Created by Aylwing Olivas on 8/16/18.
//  Copyright © 2018 Instacart. All rights reserved.
//

import Foundation

enum APIError: Error {
    case noQuestions
    case invalidData
    case nilRequest
    case otherError(Error)

    var localizedDescription: String {

        switch self {
        case .noQuestions:
            return "Couldn't load data. If the problem persists, please contact us."

        case .nilRequest, .invalidData, .otherError:
            return "An error occurred. Please try again."
        }
    }
}

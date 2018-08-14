//
//  ViewError.swift
//  Grocery Challenge
//
//  Created by Aylwing Olivas on 8/16/18.
//  Copyright © 2018 Instacart. All rights reserved.
//

import Foundation

struct ViewError {

    let errorDescription: String

    init(apiError: APIError) {

        // FIXME: All strings presented to user should be localized
        switch apiError {
        case .noQuestions:
            errorDescription = "Couldn't load data. If the problem persists, please contact us."

        case .nilRequest, .invalidData, .otherError:
            errorDescription = "An error occurred. Please try again."
        }
    }
}

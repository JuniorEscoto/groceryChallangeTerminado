//
//  Transition.swift
//  Grocery Challenge
//
//  Created by Aylwing Olivas on 8/16/18.
//  Copyright © 2018 Instacart. All rights reserved.
//

import Foundation

protocol TransitionDelegate: class {
    func process(transition: Transition)
}

enum Transition {
    case endShopping
    case showQuestions
}

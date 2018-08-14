//
//  InitialViewController.swift
//  Grocery Challenge
//
//  Created by Aylwing Olivas on 8/16/18.
//  Copyright © 2018 Instacart. All rights reserved.
//

import UIKit

final class InitialViewController: UIViewController {

    weak var transitionDelegate: TransitionDelegate?

    // MARK: - IBActions
    @IBAction private func beginButtonTapped(_ sender: Any) {
        transitionDelegate?.process(transition: .showQuestions)
    }
}

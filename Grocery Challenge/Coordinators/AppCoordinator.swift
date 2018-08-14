//
//  AppCoordinator.swift
//  Grocery Challenge
//
//  Created by Aylwing Olivas on 8/16/18.
//  Copyright © 2018 Instacart. All rights reserved.
//

import UIKit

final class AppCoordinator {

    // MARK: - Public Properties
    let navigationViewController = UINavigationController()

    // MARK: - Private Properties
    private let initialViewController = InitialViewController()

    // MARK: - Public functions
    func start() {
        initialViewController.transitionDelegate = self
        navigationViewController.viewControllers = [initialViewController]
        navigationViewController.isNavigationBarHidden = true
    }
}

extension AppCoordinator: TransitionDelegate {

    func process(transition: Transition) {
        switch transition {

        case .endShopping:
            navigationViewController.dismiss(animated: true)

        case .showQuestions:
            let questionsViewController = QuestionsViewController()
            questionsViewController.transitionDelegate = self
            navigationViewController.present(questionsViewController, animated: true)
        }
    }
}

//
//  UIViewControllerExtension.swift
//  Grocery Challenge
//
//  Created by Aylwing Olivas on 8/16/18.
//  Copyright © 2018 Instacart. All rights reserved.
//

import UIKit

extension UIViewController {

    typealias Callback = () -> Void

    func presentAlert(title: String? = nil,
                      attributedTitle: NSMutableAttributedString? = nil,
                      message: String,
                      cancelButtonTitle: String = "",
                      acceptButtonTitle: String = "",
                      acceptButtonStyle: UIAlertActionStyle = .default,
                      cancelCallback: Callback? = nil,
                      acceptCallback: Callback? = nil) {

        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)

        if !cancelButtonTitle.isEmpty {
            let cancelAction = UIAlertAction(title: cancelButtonTitle,
                                             style: .destructive,
                                             handler: { _ in cancelCallback?() })

            alert.addAction(cancelAction)
        }

        if !acceptButtonTitle.isEmpty {
            let okAction = UIAlertAction(title: acceptButtonTitle,
                                         style: acceptButtonStyle,
                                         handler: { _ in acceptCallback?() })

            alert.addAction(okAction)
        }

        if let attributedTitle = attributedTitle {
            alert.setValue(attributedTitle, forKey: "attributedTitle")
        }

        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
}

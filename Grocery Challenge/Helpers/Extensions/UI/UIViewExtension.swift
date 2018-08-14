//
//  UIViewExtension.swift
//  Grocery Challenge
//
//  Created by Aylwing Olivas on 8/16/18.
//  Copyright © 2018 Instacart. All rights reserved.
//

import UIKit

extension UIView {

    /// Adds a view as a subview and constrains it to the edges
    ///
    /// - Parameter subview: view to add as subview and constrain
    internal func addSubViewWithFillConstraints(_ subview: UIView, margin: CGFloat = 0) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false

        subview.topAnchor.constraint(equalTo: topAnchor, constant: margin).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin).isActive = true
        subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin).isActive = true
        subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin).isActive = true
    }

    static func buildNib<T: UIView>() -> T {
        let nibName = String(describing: T.self)
        guard let nibView = Bundle(for: T.self).loadNibNamed(nibName, owner: self)?.first as? T else {
            assertionFailure("Unable to load a nibView for \(nibName)")
            return T()
        }

        return nibView
    }
}

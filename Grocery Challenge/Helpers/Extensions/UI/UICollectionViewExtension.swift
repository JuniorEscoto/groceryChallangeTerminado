//
//  UICollectionViewExtension.swift
//  Grocery Challenge
//
//  Created by Aylwing Olivas on 8/16/18.
//  Copyright © 2018 Instacart. All rights reserved.
//

import UIKit

extension UICollectionView {

    func register<T: UICollectionViewCell>(cellType: T.Type) {
        let reuseIdentifier = String(describing: T.self)
        register(UINib(nibName: reuseIdentifier, bundle: Bundle(for: T.self)), forCellWithReuseIdentifier: reuseIdentifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        let reuseIdentifier = String(describing: T.self)
        guard let cell = dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? T else {
            assertionFailure("Unable to dequeue a cell for \(reuseIdentifier)")
            return T()
        }

        return cell
    }
}


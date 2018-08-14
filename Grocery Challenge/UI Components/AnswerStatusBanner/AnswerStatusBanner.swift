//
//  AnswerStatusBanner.swift
//  Grocery Challenge
//
//  Created by Aylwing Olivas on 8/16/18.
//  Copyright © 2018 Instacart. All rights reserved.
//

import UIKit

final class AnswerStatusBanner: UIView {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var label: UILabel!

    static let nibView: AnswerStatusBanner = buildNib()

    enum BannerType {
        case success
        case error
    }

    func showBanner(text: String?, bannerType: BannerType) {

        label.text = text
        switch bannerType {
        case .success:
            imageView.image = #imageLiteral(resourceName: "CheckMarkIcon")
            backgroundColor = #colorLiteral(red: 0.02745098039, green: 0.7137254902, blue: 0.1411764706, alpha: 1).withAlphaComponent(0.8)

        case .error:
            imageView.image = #imageLiteral(resourceName: "xIconWhite")
            backgroundColor = #colorLiteral(red: 1, green: 0.1834241059, blue: 0.1559909122, alpha: 1).withAlphaComponent(0.8)
        }
    }
}

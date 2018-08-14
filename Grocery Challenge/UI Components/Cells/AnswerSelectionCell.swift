//
//  AnswerSelectionCell.swift
//  Grocery Challenge
//
//  Created by Aylwing Olivas on 8/16/18.
//  Copyright © 2018 Instacart. All rights reserved.
//

import UIKit
import SDWebImage

final class AnswerSelectionCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!

    var didTap: (() -> Void)?

    var cellIsSelected: Bool = false {
        didSet {
            contentView.layer.borderColor = cellIsSelected ? UIColor.green.cgColor : UIColor.clear.cgColor
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }

    func download(url: URL?) {
        imageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "EmptyImagePlaceholder"))
    }

    private func setUI() {
        cellIsSelected = false
        contentView.layer.borderWidth = 1
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        contentView.addGestureRecognizer(tap)
    }

    @objc private func handleTap() {
        didTap?()
        cellIsSelected = true
    }
}

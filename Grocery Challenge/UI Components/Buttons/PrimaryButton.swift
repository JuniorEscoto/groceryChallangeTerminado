//
//  PrimaryButton.swift
//  Grocery Challenge
//
//  Created by Aylwing Olivas on 8/16/18.
//  Copyright © 2018 Instacart. All rights reserved.
//

import UIKit

@IBDesignable final class PrimaryButton: UIButton {

    // MARK: - Private properties
    private lazy var highlightLayer: CALayer = {
        clipsToBounds = true
        let highlight = CALayer()
        highlight.frame = bounds
        highlight.backgroundColor = UIColor.black.withAlphaComponent(0.1).cgColor
        layer.addSublayer(highlight)
        return highlight
    }()

    // MARK: - Overrides
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setUI()
    }

    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        setUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUI()
    }

    override var isHighlighted: Bool {
        didSet {
            highlightLayer.isHidden = !isHighlighted
        }
    }

    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? #colorLiteral(red: 0.02745098039, green: 0.7137254902, blue: 0.1411764706, alpha: 1) : UIColor.lightGray
        }
    }

    // MARK: - Private functions
    private func setUI() {
        backgroundColor = #colorLiteral(red: 0.02745098039, green: 0.7137254902, blue: 0.1411764706, alpha: 1)
        layer.cornerRadius = 15
        setTitleColor(.white, for: .normal)
    }
}

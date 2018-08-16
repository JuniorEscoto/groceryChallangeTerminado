//
//  NSMutableAttributedStringExtension.swift
//  Grocery Challenge
//
//  Created by Aylwing Olivas on 8/16/18.
//  Copyright © 2018 Instacart. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {

    @discardableResult func text(_ text: String?,
                                 size: CGFloat = 16,
                                 color: UIColor = .black) -> NSMutableAttributedString {

        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: size, weight: UIFont.Weight.regular),
                          NSAttributedStringKey.foregroundColor: color]

        let string = NSMutableAttributedString(string: text ?? "", attributes: attributes)
        self.append(string)
        return self
    }

    @discardableResult func semiboldText(_ text: String?,
                                         size: CGFloat = 16,
                                         color: UIColor = .black) -> NSMutableAttributedString {

        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: size, weight: UIFont.Weight.semibold),
                          NSAttributedStringKey.foregroundColor: color]

        let boldString = NSMutableAttributedString(string: text ?? "", attributes: attributes)
        self.append(boldString)
        return self
    }

    @discardableResult func image(_ image: UIImage?) -> NSMutableAttributedString {
        let textAttachment = NSTextAttachment()
        textAttachment.image = image
        self.append(NSAttributedString(attachment: textAttachment))
        return self
    }

    @discardableResult func newLine() -> NSMutableAttributedString {
        let newLine = NSMutableAttributedString(string: "\n")
        self.append(newLine)
        return self
    }
}


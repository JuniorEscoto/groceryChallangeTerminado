//
//  NSMutableAttributedStringExtension.swift
//  Grocery Challenge
//
//  Created by Aylwing Olivas on 8/16/18.
//  Copyright © 2018 Instacart. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {

    @discardableResult func text(_ text: String) -> NSMutableAttributedString {
        let string = NSMutableAttributedString(string: text)
        self.append(string)
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


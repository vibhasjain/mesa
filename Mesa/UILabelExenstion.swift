//
//  UILabelExenstion.swift
//  Mesa
//
//  Created by Vibes on 5/20/17.
//  Copyright © 2017 PZRT. All rights reserved.
//


import UIKit

extension UILabel {
    
    func setLineHeight(lineHeight: CGFloat) {
        let text = self.text
        if let text = text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            
            style.lineSpacing = lineHeight
            attributeString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, text.characters.count))
            self.attributedText = attributeString
            self.textAlignment = NSTextAlignment.center

        }
    }
}

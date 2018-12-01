//
//  UIImage+Utilities.swift
//  ManaKit
//
//  Created by Jovito Royeca on 10/06/2018.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {
    public func roundCornered(card: CMCard) -> UIImage {
        var radius = CGFloat(22)

        if let set = card.set {
            if set.code == "LEA" {
                radius = 34
            } else if set.code == "CEI" ||
                set.code == "CED" {
                return self
            }
        }

        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: 0, y: 0),
                                         size: self.size),
                     cornerRadius: radius).addClip()
        self.draw(in:  CGRect(origin: CGPoint(x: 0, y: 0), size: self.size))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return result!
    }
}

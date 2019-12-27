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
    func roundCornered(card: MGCard) -> UIImage {
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
    
    func rotate(angle: CGFloat) -> UIImage? {
        let ciImage = CIImage(image: self)
        
        let filter = CIFilter(name: "CIAffineTransform")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setDefaults()
        
        let newAngle = angle * CGFloat(-1)
        
        var transform = CATransform3DIdentity
        transform = CATransform3DRotate(transform, CGFloat(newAngle), 0, 0, 1)
        
        let affineTransform = CATransform3DGetAffineTransform(transform)
        
        filter?.setValue(NSValue(cgAffineTransform: affineTransform), forKey: "inputTransform")
        
        let contex = CIContext(options: [CIContextOption.useSoftwareRenderer: true])
        let outputImage = filter?.outputImage
        let cgImage = contex.createCGImage(outputImage!, from: (outputImage?.extent)!)
        
        let result = UIImage(cgImage: cgImage!)
        return result
    }
}

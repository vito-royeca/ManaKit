//
//  ManaKitUtilities+Imaging.swift
//  ManaKit
//
//  Created by Vito Royeca on 4/15/26.
//

#if canImport(UIKit)
import UIKit

extension ManaKitUtilities {
    public func image(name: ImageName) -> UIImage? {
        if let path = Bundle.module.path(forResource: name.rawValue, ofType: "png") {
            return UIImage(contentsOfFile: path)
        } else {
            return nil
        }
    }

    public func image(fileName: String) -> UIImage? {
        if let name = fileName.split(separator: ".").first,
           let ext = fileName.split(separator: ".").last,
           let path = Bundle.module.path(forResource: String(name), ofType: String(ext)) {
            return UIImage(contentsOfFile: path)
        } else {
            return nil
        }
    }
    
    public func symbolImage(name: String) -> UIImage? {
        return UIImage(named: name, in: Bundle.module, compatibleWith: nil)
    }
}
#endif

//
//  ManaKit+Imaging.swift
//  Pods
//
//  Created by Vito Royeca on 11/27/19.
//

#if canImport(UIKit)
import UIKit

extension ManaKit {
    public func image(name: ImageName) -> UIImage? {
        if let path = Bundle.module.path(forResource: name.rawValue, ofType: "png") {
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

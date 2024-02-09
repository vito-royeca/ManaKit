//
//  ManaKit+SwiftData.swift
//
//
//  Created by Vito Royeca on 2/8/24.
//

import Foundation

// MARK: - Base class

public class SDEntity: Identifiable {
//    convenience init(from entity: MEntity) {
//        self.init(context: context)
//    }
    
    func update<T>(keyPath: ReferenceWritableKeyPath<SDEntity, T>, to value: T) {
        self[keyPath: keyPath] = value
//        lastModified = .now
    }
}

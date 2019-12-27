//
//  BSTree.swift
//  ManaKit_Example
//
//  Created by Jovito Royeca on 17/11/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class BSTree: NSObject {
    var key: Int
    var data: Any
    var left: BSTree?
    var right: BSTree?
    
    init(_ key: Int, data: Any) {
        self.key = key
        self.data = data
    }
    
    func insert(_ key: Int, data: Any) {
        if key <= self.key {
            if left == nil {
                left = BSTree(key, data: data)
            } else {
                left!.insert(key, data: data)
            }
        } else  {
            if right == nil {
                right = BSTree(key, data: data)
            } else {
                right!.insert(key, data: data)
            }
        }
    }
    
    func contains(_ key: Int) -> Bool {
        if key == self.key {
            return true
        } else if key <= self.key {
            if left == nil {
                return false
            } else {
                return left!.contains(key)
            }
        } else {
            if right == nil {
                return false
            } else {
                return right!.contains(key)
            }
        }
    }
    
    func search(_ key: Int) -> BSTree? {
        if key == self.key {
            return self
        } else if key <= self.key {
            if left == nil {
                return nil
            } else {
                return left!.search(key)
            }
        } else {
            if right == nil {
                return nil
            } else {
                return right!.search(key)
            }
        }
    }

    func printInOrder() {
        if let left = left {
            left.printInOrder()
        }
        print("\(key)")
        if let right = right {
            right.printInOrder()
        }
    }
    
    func printPreOrder() {
        print("\(key)")
        if let left = left {
            left.printInOrder()
        }
        if let right = right {
            right.printInOrder()
        }
    }
    
    func printPostOrder() {
        if let left = left {
            left.printInOrder()
        }
        if let right = right {
            right.printInOrder()
        }
        print("\(key)")
    }
}

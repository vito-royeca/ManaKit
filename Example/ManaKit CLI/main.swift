//
//  main.swift
//  ManaKit CLI
//
//  Created by Vito Royeca on 12/14/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

print("docsPath = \(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])")
let maintainer = Maintainer()
maintainer.checkServerInfo()


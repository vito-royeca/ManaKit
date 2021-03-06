//
//  ManaKit+Error.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/20/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

public enum ManaKitError: Error {
  case missingManagedObjectContext
  case missingPersistentContainer
}

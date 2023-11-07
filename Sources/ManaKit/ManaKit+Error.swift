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
    case badURL
    case invalidHttpResponse
}

public enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
}

public enum JSONDataError: Error {
    case unableToParse
}

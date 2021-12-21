//
//  ManaKit+Codable.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/16/21.
//

import CoreData

// MARK: - Errors

public enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
}

public enum JSONDataError: Error {
    case unableToParse
}

// MARK: - CodingUserInfoKey

public extension CodingUserInfoKey {
  static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

public class MGLocalCache: NSManagedObject {
    
}

public class MGServerInfo: NSManagedObject {
    
}

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

// MARK: - Classes and Protocols

public class MGEntity: NSManagedObject, Codable {
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)
    }
    
//    public func encode(to encoder: Encoder) throws {}
}

public class MGLocalCache: MGEntity {
    
}


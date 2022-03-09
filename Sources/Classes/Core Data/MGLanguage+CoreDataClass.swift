//
//  MGLanguage+CoreDataClass.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/17/21.
//

import CoreData

public class MGLanguage: MGEntity {
    enum CodingKeys: CodingKey {
        case code,
             displayCode,
             name,
             nameSection,
             cards,
             sets
    }

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // code
        if let code = try container.decodeIfPresent(String.self, forKey: .code),
           self.code != code {
            self.code = code
        }
        
        // displayCode
        if let displayCode = try container.decodeIfPresent(String.self, forKey: .displayCode),
           self.displayCode != displayCode {
            self.displayCode = displayCode
        }
        
        // name
        if let name = try container.decodeIfPresent(String.self, forKey: .name),
           self.name != name {
            self.name = name
        }
        
        // nameSection
        if let nameSection = try container.decodeIfPresent(String.self, forKey: .nameSection),
           self.nameSection != nameSection {
            self.nameSection = nameSection
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(code, forKey: .code)
        try container.encode(displayCode, forKey: .displayCode)
        try container.encode(name, forKey: .name)
        try container.encode(nameSection, forKey: .nameSection)
    }
    
//    func toModel() -> MLanguage {
//        return MLanguage(code: code,
//                         displayCode: displayCode,
//                         name: name,
//                         nameSection: nameSection)
//    }
}

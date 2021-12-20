//
//  MGSet+Codable.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/17/21.
//

import CoreData

public class MGSet: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case cardCount,
             code,
             dateCreated,
             dateUpdated,
             isFoilOnly,
             isOnlineOnly,
             keyruneClass,
             keyruneUnicode,
             mtgoCode,
             myNameSection,
             myYearSection,
             name,
             releaseDate,
             tcgPlayerId,
             cards,
             children,
             languages,
             parent,
             setBlock,
             setType
    }

    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        cardCount = try container.decode(Int32.self, forKey: .cardCount)
        code = try container.decode(String.self, forKey: .code)
        dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        dateUpdated = try container.decode(Date.self, forKey: .dateUpdated)
        isFoilOnly = try container.decode(Bool.self, forKey: .isFoilOnly)
        isOnlineOnly = try container.decode(Bool.self, forKey: .isOnlineOnly)
        keyruneClass = try container.decode(String.self, forKey: .keyruneClass)
        keyruneUnicode = try container.decode(String.self, forKey: .keyruneUnicode)
        mtgoCode = try container.decode(String.self, forKey: .mtgoCode)
        myNameSection = try container.decode(String.self, forKey: .myNameSection)
        myYearSection = try container.decode(String.self, forKey: .myYearSection)
        name = try container.decode(String.self, forKey: .name)
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
        tcgPlayerId = try container.decode(Int32.self, forKey: .tcgPlayerId)
        cards = try container.decode(Set<MGCard>.self, forKey: .cards) as NSSet
        children = try container.decode(Set<MGSet>.self, forKey: .children) as NSSet
        languages = try container.decode(Set<MGLanguage>.self, forKey: .languages) as NSSet
        parent = try container.decode(MGSet.self, forKey: .parent)
        setBlock = try container.decode(MGSetBlock.self, forKey: .setBlock)
        setType = try container.decode(MGSetType.self, forKey: .setType)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(cardCount, forKey: .cardCount)
        try container.encode(code, forKey: .code)
        try container.encode(dateCreated, forKey: .dateCreated)
        try container.encode(dateUpdated, forKey: .dateUpdated)
        try container.encode(isFoilOnly, forKey: .isFoilOnly)
        try container.encode(isOnlineOnly, forKey: .isOnlineOnly)
        try container.encode(keyruneClass, forKey: .keyruneClass)
        try container.encode(keyruneUnicode, forKey: .keyruneUnicode)
        try container.encode(mtgoCode, forKey: .mtgoCode)
        try container.encode(myNameSection, forKey: .myNameSection)
        try container.encode(myYearSection, forKey: .myYearSection)
        try container.encode(name, forKey: .name)
        try container.encode(releaseDate, forKey: .releaseDate)
        try container.encode(tcgPlayerId, forKey: .tcgPlayerId)
        try container.encode(cards as! Set<MGCard>, forKey: .cards)
        try container.encode(children as! Set<MGSet>, forKey: .children)
        try container.encode(languages as! Set<MGLanguage>, forKey: .languages)
        try container.encode(parent, forKey: .parent)
        try container.encode(setBlock, forKey: .setBlock)
        try container.encode(setType, forKey: .setType)
    }
}

extension MGSet {
    public func keyrune2Unicode() -> String {
        let charAsInt = Int(keyruneUnicode ?? "", radix: 16)!
        let uScalar = UnicodeScalar(charAsInt)!
        let unicode = "\(uScalar)"
        
        return unicode
    }
}

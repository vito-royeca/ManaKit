//
//  MGSet+Codable.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/17/21.
//

import CoreData

public class MGSet: MGEntity {
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
        
        cardCount = try container.decodeIfPresent(Int32.self, forKey: .cardCount) ?? Int32(0)
        code = try container.decodeIfPresent(String.self, forKey: .code)
        dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        dateUpdated = try container.decodeIfPresent(Date.self, forKey: .dateUpdated)
        isFoilOnly = try container.decodeIfPresent(Bool.self, forKey: .isFoilOnly) ?? false
        isOnlineOnly = try container.decodeIfPresent(Bool.self, forKey: .isOnlineOnly) ?? false
        keyruneClass = try container.decodeIfPresent(String.self, forKey: .keyruneClass)
        keyruneUnicode = try container.decodeIfPresent(String.self, forKey: .keyruneUnicode)
        mtgoCode = try container.decodeIfPresent(String.self, forKey: .mtgoCode)
        myNameSection = try container.decodeIfPresent(String.self, forKey: .myNameSection)
        myYearSection = try container.decodeIfPresent(String.self, forKey: .myYearSection)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        tcgPlayerId = try container.decodeIfPresent(Int32.self, forKey: .tcgPlayerId) ?? Int32(0)
        cards = try container.decodeIfPresent(Set<MGCard>.self, forKey: .cards) as NSSet?
        children = try container.decodeIfPresent(Set<MGSet>.self, forKey: .children) as NSSet?
        // Don't include many-to-many relations
//        languages = try container.decodeIfPresent(Set<MGLanguage>.self, forKey: .languages) as NSSet?
        parent = try container.decodeIfPresent(MGSet.self, forKey: .parent)
        setBlock = try container.decodeIfPresent(MGSetBlock.self, forKey: .setBlock)
        setType = try container.decodeIfPresent(MGSetType.self, forKey: .setType)
    }
    
    public override func encode(to encoder: Encoder) throws {
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
        // Don't include many-to-many relations
//        try container.encode(languages as! Set<MGLanguage>, forKey: .languages)
        try container.encode(parent, forKey: .parent)
        try container.encode(setBlock, forKey: .setBlock)
        try container.encode(setType, forKey: .setType)
    }
}

extension MGSet {
    public func keyrune2Unicode() -> String {
        let keyruneUnicode = keyruneUnicode ?? "e684"
        
        guard let charAsInt = Int(keyruneUnicode, radix: 16),
           let uScalar = UnicodeScalar(charAsInt) else {
            return ""
        }
        let unicode = "\(uScalar)"
        
        return unicode
    }
}

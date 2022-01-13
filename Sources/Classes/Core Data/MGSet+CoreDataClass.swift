//
//  MGSet+CoreDataClass.swift
//  ManaKit
//
//  Created by Vito Royeca on 12/17/21.
//

import CoreData

class MGSet: MGEntity {
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

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw DecoderConfigurationError.missingManagedObjectContext
        }

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.init(context: context)
        
        // MARK: - attributes
        
        // cardCount
        if let cardCount = try container.decodeIfPresent(Int32.self, forKey: .cardCount),
           self.cardCount != cardCount {
            self.cardCount = cardCount
        }
        
        // code
        if let code = try container.decodeIfPresent(String.self, forKey: .code),
           self.code != code {
            self.code = code
        }
        
        // isFoilOnly
        if let isFoilOnly = try container.decodeIfPresent(Bool.self, forKey: .isFoilOnly),
           self.isFoilOnly != isFoilOnly {
            self.isFoilOnly = isFoilOnly
        }
        
        // isOnlineOnly
        if let isOnlineOnly = try container.decodeIfPresent(Bool.self, forKey: .isOnlineOnly),
           self.isOnlineOnly != isOnlineOnly {
            self.isOnlineOnly = isOnlineOnly
        }
        
        // keyruneClass
        if let keyruneClass = try container.decodeIfPresent(String.self, forKey: .keyruneClass),
           self.keyruneClass != keyruneClass {
            self.keyruneClass = keyruneClass
        }
        
        // keyruneUnicode
        if let keyruneUnicode = try container.decodeIfPresent(String.self, forKey: .keyruneUnicode),
           self.keyruneUnicode != keyruneUnicode {
            self.keyruneUnicode = keyruneUnicode
        }
        
        // mtgoCode
        if let mtgoCode = try container.decodeIfPresent(String.self, forKey: .mtgoCode),
           self.mtgoCode != mtgoCode {
            self.mtgoCode = mtgoCode
        }
        
        // myNameSection
        if let myNameSection = try container.decodeIfPresent(String.self, forKey: .myNameSection),
           self.myNameSection != myNameSection {
            self.myNameSection = myNameSection
        }
        
        // myYearSection
        if let myYearSection = try container.decodeIfPresent(String.self, forKey: .myYearSection),
           self.myYearSection != myYearSection {
            self.myYearSection = myYearSection
        }
        
        // name
        if let name = try container.decodeIfPresent(String.self, forKey: .name),
           self.name != name {
            self.name = name
        }

        // releaseDate
        if let releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate) {
            self.releaseDate = releaseDate
        }
        
        // tcgPlayerId
        if let tcgPlayerId = try container.decodeIfPresent(Int32.self, forKey: .tcgPlayerId),
           self.tcgPlayerId != tcgPlayerId {
            self.tcgPlayerId = tcgPlayerId
        }

        // MARK: - relationships
        
        // cards
        if let cards = try container.decodeIfPresent(Set<MGCard>.self, forKey: .cards),
           !cards.isEmpty {
            for card in self.cards?.allObjects as? [MGCard] ?? [] {
                self.removeFromCards(card)
            }
            addToCards(cards as NSSet)
            
            cards.forEach {
                $0.set = self
            }
        }

        // children
        if let children = try container.decodeIfPresent(Set<MGSet>.self, forKey: .children),
           !children.isEmpty {
            for child in self.children?.allObjects as? [MGSet] ?? [] {
                self.removeFromChildren(child)
            }
            
            children.forEach {
                $0.parent = self
            }
            addToChildren(children as NSSet)
        }
        
        // languages
//        if let languages = try container.decodeIfPresent(Set<MGLanguage>.self, forKey: .languages) {
//            for language in self.languages?.allObjects as? [MGLanguage] ?? [] {
//                self.removeFromLanguages(language)
//            }
//            
//            languages.forEach {
//                $0.addToSets(self)
//            }
//            addToLanguages(languages as NSSet)
//        }
        
        // parent
//        if let parent = try container.decodeIfPresent(MGSet.self, forKey: .parent) {
//            self.parent = parent
//        }
        
        // setBlock
//        if let setBlock = try container.decodeIfPresent(MGSetBlock.self, forKey: .setBlock) {
//            self.setBlock = setBlock
//        }
        
        // setType
//        if let setType = try container.decodeIfPresent(MGSetType.self, forKey: .setType) {
//            self.setType = setType
//        }
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(cardCount, forKey: .cardCount)
        try container.encode(code, forKey: .code)
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
        if let cards = cards as? Set<MGCard> {
            try container.encode(cards, forKey: .cards)
        }
        if let children = children as? Set<MGSet> {
            try container.encode(children, forKey: .children)
        }
        if let languages = languages as? Set<MGLanguage> {
            try container.encode(languages, forKey: .languages)
        }
        if let parent = parent {
            try container.encode(parent, forKey: .parent)
        }
        if let setBlock = setBlock {
            try container.encode(setBlock, forKey: .setBlock)
        }
        if let setType = setType {
            try container.encode(setType, forKey: .setType)
        }
    }
    
    func toModel() -> MSet {
        return MSet(cardCount: cardCount,
                    code: code,
                    isFoilOnly: isFoilOnly,
                    isOnlineOnly: isOnlineOnly,
                    keyruneClass: keyruneClass,
                    keyruneUnicode: keyruneUnicode,
                    mtgoCode: mtgoCode,
                    myNameSection: myNameSection,
                    myYearSection: myYearSection,
                    name: name,
                    releaseDate: releaseDate,
                    tcgPlayerId: tcgPlayerId,
//                    cards: (cards?.allObjects as? [MGCard] ?? [MGCard]()).map { $0.toModel() },
                    children: (children?.allObjects as? [MGSet] ?? [MGSet]()).map { $0.toModel() },
                    languages: (languages?.allObjects as? [MGLanguage] ?? [MGLanguage]()).map { $0.toModel() },
                    setBlock: setBlock?.toModel(),
                    setType: setType?.toModel())
    }
}


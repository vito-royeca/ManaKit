//
//  SetModel.swift
//  ManaKit
//
//  Created by Vito Royeca on 10/8/21.
//

import Foundation

public struct SetModel: Codable {
    public var cardCount: Int32
    public var code: String
    public var dateCreated: Date?
    public var dateUpdated: Date?
    public var isFoilOnly: Bool
    public var isOnlineOnly: Bool
    public var keyruneClass: String
    public var keyruneUnicode: String
    public var mtgoCode: String
    public var myNameSection: String
    public var myYearSection: String
    public var name: String
    public var releaseDate: String
    public var tcgPlayerId: Int32
    
    public init(cardCount: Int32,
                code: String,
                dateCreated: Date?,
                dateUpdated: Date?,
                isFoilOnly: Bool,
                isOnlineOnly: Bool,
                keyruneClass: String,
                keyruneUnicode: String,
                mtgoCode: String,
                myNameSection: String,
                myYearSection: String,
                name: String,
                releaseDate: String,
                tcgPlayerId: Int32) {
        
        self.cardCount = cardCount
        self.code = code
        self.dateCreated = dateCreated
        self.dateUpdated = dateUpdated
        self.isFoilOnly = isFoilOnly
        self.isOnlineOnly = isOnlineOnly
        self.keyruneClass = keyruneClass
        self.keyruneUnicode = keyruneUnicode
        self.mtgoCode = mtgoCode
        self.myNameSection = myNameSection
        self.myYearSection = myYearSection
        self.name = name
        self.releaseDate = releaseDate
        self.tcgPlayerId = tcgPlayerId
    }
    
    public func keyrune2Unicode() -> String {
        let charAsInt = Int(keyruneUnicode, radix: 16)!
        let uScalar = UnicodeScalar(charAsInt)!
        let unicode = "\(uScalar)"
        
        return unicode
    }
}

extension MGSet {
    public func toModel() -> SetModel {
        SetModel(
            cardCount: cardCount,
            code: code ?? "",
            dateCreated: dateCreated,
            dateUpdated: dateUpdated,
            isFoilOnly: isFoilOnly,
            isOnlineOnly: isOnlineOnly,
            keyruneClass: keyruneClass ?? "",
            keyruneUnicode: keyruneUnicode ?? "",
            mtgoCode: mtgoCode ?? "",
            myNameSection: myNameSection ?? "",
            myYearSection: myYearSection ?? "",
            name: name ?? "",
            releaseDate: releaseDate ?? "",
            tcgPlayerId: tcgPlayerId
        )
    }
}

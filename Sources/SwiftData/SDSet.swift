//
//  SDSet.swift
//  ManaKit
//
//  Created by Vito Royeca on 10/26/25.
//

import Foundation
import SwiftData

@Model
final public class SDSet {
    public var bigLogoURL: String?
    public var cardCount: Int32
    public var code: String
    public var isFoilOnly: Bool
    public var isOnlineOnly: Bool
    public var keyruneClass: String
    public var keyruneUnicode: String
    public var logoCode: String?
    public var mtgoCode: String?
    public var name: String
    public var releaseDate: Date
    public var smallLogoURL: String?
    public var tcgPlayerID: Int32
    public var yearSection: String
    
//    public var cards: NSSet?
//    public var children: NSSet?
//    public var languages: NSSet?
//    public var parent: SDSet?
//    public var setBlock: SDSetBlock?
//    public var setType: SDSetType?
    
    public init(bigLogoURL: String?,
                cardCount: Int32,
                code: String,
                isFoilOnly: Bool,
                isOnlineOnly: Bool,
                keyruneClass: String,
                keyruneUnicode: String,
                logoCode: String?,
                mtgoCode: String?,
                name: String,
                releaseDate: Date,
                smallLogoURL: String?,
                tcgPlayerID: Int32,
                yearSection: String) {

        self.bigLogoURL = bigLogoURL
        self.cardCount = cardCount
        self.code = code
        self.isFoilOnly = isFoilOnly
        self.isOnlineOnly = isOnlineOnly
        self.keyruneClass = keyruneClass
        self.keyruneUnicode = keyruneUnicode
        self.logoCode = logoCode
        self.mtgoCode = mtgoCode
        self.name = name
        self.releaseDate = releaseDate
        self.smallLogoURL = smallLogoURL
        self.tcgPlayerID = tcgPlayerID
        self.yearSection = yearSection
    }
}

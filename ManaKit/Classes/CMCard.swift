//
//  CMCard.swift
//  Pods
//
//  Created by Jovito Royeca on 26/12/2018.
//
//

import Foundation
import RealmSwift

public class CMCard: Object {

    @objc public dynamic var arenaID: String? = nil
    @objc public dynamic var collectorNumber: String? = nil
    @objc public dynamic var convertedManaCost = Double(0)
    @objc public dynamic var displayName: String? = nil
    @objc public dynamic var faceOrder = Int32(0)
    @objc public dynamic var firebaseID: String? = nil
    @objc public dynamic var firebaseRating = Double(0)
    @objc public dynamic var firebaseRatings = Int32(0)
    @objc public dynamic var firebaseViews = Int64(0)
    @objc public dynamic var firebaseLastUpdate: Date? = nil
    @objc public dynamic var flavorText: String? = nil
    @objc public dynamic var id: String? = nil
    @objc public dynamic var illustrationID: String? = nil
    @objc public dynamic var imageURIs: Data? = nil
    @objc public dynamic var internalID = Int32(0)
    @objc public dynamic var isColorshifted = false
    @objc public dynamic var isDigital = false
    @objc public dynamic var isFoil = false
    @objc public dynamic var isFullArt = false
    @objc public dynamic var isFutureshifted = false
    @objc public dynamic var isHighResImage = false
    @objc public dynamic var isNonFoil = false
    @objc public dynamic var isOversized = false
    @objc public dynamic var isReprint = false
    @objc public dynamic var isReserved = false
    @objc public dynamic var isStorySpotlight = false
    @objc public dynamic var isTimeshifted = false
    @objc public dynamic var loyalty: String? = nil
    @objc public dynamic var manaCost: String? = nil
    @objc public dynamic var mtgoFoilID: String? = nil
    @objc public dynamic var mtgoID: String? = nil
    @objc public dynamic var multiverseIDs: Data? = nil
    @objc public dynamic var myNameSection: String? = nil
    @objc public dynamic var myNumberOrder = Double(0)
    @objc public dynamic var name: String? = nil
    @objc public dynamic var oracleID: String? = nil
    @objc public dynamic var oracleText: String? = nil
    @objc public dynamic var power: String? = nil
    @objc public dynamic var printedName: String? = nil
    @objc public dynamic var printedText: String? = nil
    @objc public dynamic var releaseDate: String? = nil
    @objc public dynamic var tcgPlayerPurchaseURI: String? = nil
    @objc public dynamic var tcgPlayerID = Int32(0)
    @objc public dynamic var tcgPlayerLstUpdate: Date? = nil
    @objc public dynamic var toughness: String? = nil
    
    // MARK: Relationships
    @objc public dynamic var artist: CMCardArtist?
    @objc public dynamic var borderColor: CMCardBorderColor?
    public let cardLegalities = List<CMCardLegality>()
    public let cardRulings = List<CMCardRuling>()
    public let colors = List<CMCardColor>()
    public let colorIdentities = List<CMCardColor>()
    public let colorIndicators = List<CMCardColor>()
    public let deckHeroes = List<CMDeck>()
    @objc public dynamic var face: CMCard?
    public let faces = List<CMCard>()
    public let firebaseUserFavorites = List<CMUser>()
    public let firebaseUserRatings = List<CMCardRating>()
    @objc public dynamic var frame: CMCardFrame?
    @objc public dynamic var frameEffect: CMCardFrameEffect?
    public let inventories = List<CMInventory>()
    @objc public dynamic var language: CMLanguage?
    @objc public dynamic var layout: CMCardLayout?
    @objc public dynamic var myType: CMCardType?
    public let otherLanguages = List<CMCard>()
    public let otherPrintings = List<CMCard>()
    @objc public dynamic var part: CMCard?
    public let parts = List<CMCard>()
    public let pricings = List<CMCardPricing>()
    @objc public dynamic var printedTypeLine: CMCardType?
    @objc public dynamic var rarity: CMCardRarity?
    @objc public dynamic var set: CMSet?
    @objc public dynamic var tcgplayerStorePricing: CMStorePricing?
    @objc public dynamic var typeLine: CMCardType?
    public let variations = List<CMCard>()
    @objc public dynamic var watermark: CMCardWatermark?
    
    // MARK: Primary key
    override public static func primaryKey() -> String? {
        return "internalID"
    }

    // MARK: Custom methods
    public func willUpdateTCGPlayerCardPricing() -> Bool {
        var willUpdate = false
        
        if let lastUpdate = tcgPlayerLstUpdate {
            if let diff = Calendar.current.dateComponents([.hour],
                                                          from: lastUpdate as Date,
                                                          to: Date()).hour {
                if diff >= ManaKit.Constants.TcgPlayerPricingAge {
                    willUpdate = true
                }
            }
        } else {
            willUpdate = true
        }
        
        return willUpdate
    }
    
    public func willUpdateTCGPlayerStorePricing() -> Bool {
        var willUpdate = false
        
        if let storePricing = tcgplayerStorePricing,
            let lastUpdate = storePricing.lastUpdate {
            
            if let diff = Calendar.current.dateComponents([.hour],
                                                          from: lastUpdate as Date,
                                                          to: Date()).hour {
                
                if diff >= ManaKit.Constants.TcgPlayerPricingAge {
                    willUpdate = true
                }
            }
        }
        
        return willUpdate
    }
    
    public func willUpdateFirebaseData() -> Bool {
        var willUpdate = false
        
        if let lastUpdate = firebaseLastUpdate {
            
            if let diff = Calendar.current.dateComponents([.second],
                                                          from: lastUpdate as Date,
                                                          to: Date()).second {
                
                if diff >= ManaKit.Constants.FirebaseDataAge {
                    willUpdate = true
                }
            }
        }
        
        return willUpdate
    }
}


//
//  CMCard+CoreDataProperties.swift
//  Pods
//
//  Created by Jovito Royeca on 15/04/2017.
//
//

import Foundation
import CoreData


extension CMCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMCard> {
        return NSFetchRequest<CMCard>(entityName: "CMCard")
    }

    @NSManaged public var artist: String?
    @NSManaged public var border: String?
    @NSManaged public var cmc: Double
    @NSManaged public var colorIdentity: Data?
    @NSManaged public var colors: Data?
    @NSManaged public var flavor: String?
    @NSManaged public var foreignNames: Data?
    @NSManaged public var hand: Int32
    @NSManaged public var id: String?
    @NSManaged public var imageName: String?
    @NSManaged public var layout: String?
    @NSManaged public var legalities: Data?
    @NSManaged public var life: Int32
    @NSManaged public var loyalty: Int32
    @NSManaged public var manaCost: String?
    @NSManaged public var mciNumber: String?
    @NSManaged public var multiverseid: Int64
    @NSManaged public var name: String?
    @NSManaged public var nameSection: String?
    @NSManaged public var names: Data?
    @NSManaged public var number: String?
    @NSManaged public var numberOrder: Double
    @NSManaged public var originalText: String?
    @NSManaged public var originalType: String?
    @NSManaged public var power: String?
    @NSManaged public var printings: Data?
    @NSManaged public var rarity: String?
    @NSManaged public var rating: Double
    @NSManaged public var ratings: Int32
    @NSManaged public var releaseDate: String?
    @NSManaged public var reserved: Bool
    @NSManaged public var rulings: Data?
    @NSManaged public var scryfallNumber: String?
    @NSManaged public var source: String?
    @NSManaged public var starter: Bool
    @NSManaged public var storePricingLastUpdate: Date?
    @NSManaged public var storePricingNote: String?
    @NSManaged public var subtypes: Data?
    @NSManaged public var supertypes: Data?
    @NSManaged public var text: String?
    @NSManaged public var timeshifted: Bool
    @NSManaged public var toughness: String?
    @NSManaged public var type: String?
    @NSManaged public var types: Data?
    @NSManaged public var typeSection: String?
    @NSManaged public var variations: Data?
    @NSManaged public var views: Int64
    @NSManaged public var watermark: String?
    @NSManaged public var artist_: CMArtist?
    @NSManaged public var border_: CMBorder?
    @NSManaged public var cardLegalities_: NSSet?
    @NSManaged public var colorIdentities_: NSSet?
    @NSManaged public var colors_: NSSet?
    @NSManaged public var foreignNames_: NSSet?
    @NSManaged public var layout_: CMLayout?
    @NSManaged public var pricing: CMCardPricing?
    @NSManaged public var printings_: NSSet?
    @NSManaged public var rarity_: CMRarity?
    @NSManaged public var rulings_: NSSet?
    @NSManaged public var set: CMSet?
    @NSManaged public var subtypes_: NSSet?
    @NSManaged public var supertypes_: NSSet?
    @NSManaged public var suppliers: NSSet?
    @NSManaged public var type_: CMCardType?
    @NSManaged public var types_: NSSet?
    @NSManaged public var variations_: NSSet?
    @NSManaged public var names_: NSSet?
    @NSManaged public var watermark_: CMWatermark?
    @NSManaged public var deckHeroes: NSSet?
    @NSManaged public var userFavorites: NSSet?
    @NSManaged public var userRatings: NSSet?
    @NSManaged public var inventories: NSSet?
}

// MARK: Generated accessors for cardLegalities_
extension CMCard {

    @objc(addCardLegalities_Object:)
    @NSManaged public func addToCardLegalities_(_ value: CMCardLegality)

    @objc(removeCardLegalities_Object:)
    @NSManaged public func removeFromCardLegalities_(_ value: CMCardLegality)

    @objc(addCardLegalities_:)
    @NSManaged public func addToCardLegalities_(_ values: NSSet)

    @objc(removeCardLegalities_:)
    @NSManaged public func removeFromCardLegalities_(_ values: NSSet)

}

// MARK: Generated accessors for colorIdentities_
extension CMCard {

    @objc(addColorIdentities_Object:)
    @NSManaged public func addToColorIdentities_(_ value: CMColor)

    @objc(removeColorIdentities_Object:)
    @NSManaged public func removeFromColorIdentities_(_ value: CMColor)

    @objc(addColorIdentities_:)
    @NSManaged public func addToColorIdentities_(_ values: NSSet)

    @objc(removeColorIdentities_:)
    @NSManaged public func removeFromColorIdentities_(_ values: NSSet)

}

// MARK: Generated accessors for colors_
extension CMCard {

    @objc(addColors_Object:)
    @NSManaged public func addToColors_(_ value: CMColor)

    @objc(removeColors_Object:)
    @NSManaged public func removeFromColors_(_ value: CMColor)

    @objc(addColors_:)
    @NSManaged public func addToColors_(_ values: NSSet)

    @objc(removeColors_:)
    @NSManaged public func removeFromColors_(_ values: NSSet)

}

// MARK: Generated accessors for foreignNames_
extension CMCard {

    @objc(addForeignNames_Object:)
    @NSManaged public func addToForeignNames_(_ value: CMForeignName)

    @objc(removeForeignNames_Object:)
    @NSManaged public func removeFromForeignNames_(_ value: CMForeignName)

    @objc(addForeignNames_:)
    @NSManaged public func addToForeignNames_(_ values: NSSet)

    @objc(removeForeignNames_:)
    @NSManaged public func removeFromForeignNames_(_ values: NSSet)

}

// MARK: Generated accessors for printings_
extension CMCard {

    @objc(addPrintings_Object:)
    @NSManaged public func addToPrintings_(_ value: CMSet)

    @objc(removePrintings_Object:)
    @NSManaged public func removeFromPrintings_(_ value: CMSet)

    @objc(addPrintings_:)
    @NSManaged public func addToPrintings_(_ values: NSSet)

    @objc(removePrintings_:)
    @NSManaged public func removeFromPrintings_(_ values: NSSet)

}

// MARK: Generated accessors for rulings_
extension CMCard {

    @objc(addRulings_Object:)
    @NSManaged public func addToRulings_(_ value: CMRuling)

    @objc(removeRulings_Object:)
    @NSManaged public func removeFromRulings_(_ value: CMRuling)

    @objc(addRulings_:)
    @NSManaged public func addToRulings_(_ values: NSSet)

    @objc(removeRulings_:)
    @NSManaged public func removeFromRulings_(_ values: NSSet)

}

// MARK: Generated accessors for subtypes_
extension CMCard {

    @objc(addSubtypes_Object:)
    @NSManaged public func addToSubtypes_(_ value: CMCardType)

    @objc(removeSubtypes_Object:)
    @NSManaged public func removeFromSubtypes_(_ value: CMCardType)

    @objc(addSubtypes_:)
    @NSManaged public func addToSubtypes_(_ values: NSSet)

    @objc(removeSubtypes_:)
    @NSManaged public func removeFromSubtypes_(_ values: NSSet)

}

// MARK: Generated accessors for supertypes_
extension CMCard {

    @objc(addSupertypes_Object:)
    @NSManaged public func addToSupertypes_(_ value: CMCardType)

    @objc(removeSupertypes_Object:)
    @NSManaged public func removeFromSupertypes_(_ value: CMCardType)

    @objc(addSupertypes_:)
    @NSManaged public func addToSupertypes_(_ values: NSSet)

    @objc(removeSupertypes_:)
    @NSManaged public func removeFromSupertypes_(_ values: NSSet)

}

// MARK: Generated accessors for suppliers
extension CMCard {
    
    @objc(addSuppliersObject:)
    @NSManaged public func addToSuppliers(_ value: CMSupplier)
    
    @objc(removeSuppliersObject:)
    @NSManaged public func removeFromSuppliers(_ value: CMSupplier)
    
    @objc(addSuppliers:)
    @NSManaged public func addToSuppliers(_ values: NSSet)
    
    @objc(removeSuppliers:)
    @NSManaged public func removeFromSuppliers(_ values: NSSet)
    
}


// MARK: Generated accessors for types_
extension CMCard {

    @objc(addTypes_Object:)
    @NSManaged public func addToTypes_(_ value: CMCardType)

    @objc(removeTypes_Object:)
    @NSManaged public func removeFromTypes_(_ value: CMCardType)

    @objc(addTypes_:)
    @NSManaged public func addToTypes_(_ values: NSSet)

    @objc(removeTypes_:)
    @NSManaged public func removeFromTypes_(_ values: NSSet)

}

// MARK: Generated accessors for variations_
extension CMCard {

    @objc(addVariations_Object:)
    @NSManaged public func addToVariations_(_ value: CMCard)

    @objc(removeVariations_Object:)
    @NSManaged public func removeFromVariations_(_ value: CMCard)

    @objc(addVariations_:)
    @NSManaged public func addToVariations_(_ values: NSSet)

    @objc(removeVariations_:)
    @NSManaged public func removeFromVariations_(_ values: NSSet)

}

// MARK: Generated accessors for names_
extension CMCard {
    
    @objc(addNames_Object:)
    @NSManaged public func addToNames_(_ value: CMCard)
    
    @objc(removeNames_Object:)
    @NSManaged public func removeFromNames_(_ value: CMCard)
    
    @objc(addNames_:)
    @NSManaged public func addToNames_(_ values: NSSet)
    
    @objc(removeNames_:)
    @NSManaged public func removeFromNames_(_ values: NSSet)
    
}

// MARK: Generated accessors for cards
extension CMCard {
    
    @objc(addDeckHeroesObject:)
    @NSManaged public func addToDeckHeroes(_ value: CMDeck)
    
    @objc(removeDeckHeroesObject:)
    @NSManaged public func removeFromDeckHeroes(_ value: CMDeck)
    
    @objc(addDeckHeroes:)
    @NSManaged public func addToDeckHeroes(_ values: NSSet)
    
    @objc(removeDeckHeroes:)
    @NSManaged public func removeFromDeckHeroes(_ values: NSSet)
    
}

// MARK: Generated accessors for cards
extension CMCard {
    
    @objc(addUserFavoritesObject:)
    @NSManaged public func addToUserFavorites(_ value: CMCard)
    
    @objc(removeUserFavoritesObject:)
    @NSManaged public func removeFromUserFavorites(_ value: CMCard)
    
    @objc(addUserFavorites:)
    @NSManaged public func addToUserFavorites(_ values: NSSet)
    
    @objc(removeUserFavorites:)
    @NSManaged public func removeFromUserFavorites(_ values: NSSet)
    
}

// MARK: Generated accessors for favorites
extension CMCard {
    
    @objc(addRatingsObject:)
    @NSManaged public func addToRatings(_ value: CMCardRating)
    
    @objc(removeRatingsObject:)
    @NSManaged public func removeFromRatings(_ value: CMCardRating)
    
    @objc(addRatings:)
    @NSManaged public func addToRatings(_ values: NSSet)
    
    @objc(removeRatings:)
    @NSManaged public func removeFromRatings(_ values: NSSet)
    
}

// MARK: Generated accessors for cards
extension CMCard {
    
    @objc(addInventoriesObject:)
    @NSManaged public func addToInventories(_ value: CMCard)
    
    @objc(removeInventoriesObject:)
    @NSManaged public func removeFromInventories(_ value: CMCard)
    
    @objc(addInventories:)
    @NSManaged public func addToInventories(_ values: NSSet)
    
    @objc(removeInventories:)
    @NSManaged public func removeFromInventories(_ values: NSSet)
    
}



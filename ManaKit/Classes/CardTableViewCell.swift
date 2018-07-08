//
//  CardTableViewCell.swift
//  CardMagusKit
//
//  Created by Jovito Royeca on 15/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import CoreData
import PromiseKit

public let kCardTableViewCellHeight = CGFloat(88)

open class CardTableViewCell: UITableViewCell {

    // MARK: Constants
    let preEightEditionFont      = UIFont(name: "Magic:the Gathering", size: 17.0)
    let preEightEditionFontSmall = UIFont(name: "Magic:the Gathering", size: 15.0)
    let eightEditionFont         = UIFont(name: "Matrix-Bold", size: 17.0)
    let eightEditionFontSmall    = UIFont(name: "Matrix-Bold", size: 15.0)
    let magic2015Font            = UIFont(name: "Beleren", size: 17.0)
    let magic2015FontSmall       = UIFont(name: "Beleren", size: 15.0)
    
    let lowPriceColor  = UIColor.red
    let midPriceColor  = UIColor.blue
    let highPriceColor = UIColor(red:0.00, green:0.50, blue:0.00, alpha:1.0)
    let foilPriceColor = UIColor(red:0.60, green:0.51, blue:0.00, alpha:1.0)
    let normalColor = UIColor.black
    
    // Variables
    open var cardMID: NSManagedObjectID?
    
    // MARK: Outlets
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var castingCostLabel: UILabel!
    @IBOutlet weak var annotationLabel: UILabel!
    @IBOutlet weak var symbolImage: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var setImage: UILabel!
    @IBOutlet weak var lowPriceLabel: UILabel!
    @IBOutlet weak var midPriceLabel: UILabel!
    @IBOutlet weak var highPriceLabel: UILabel!
    @IBOutlet weak var foilPriceLabel: UILabel!

    // MARK: Overrides
    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // add round corners
        thumbnailImage.layer.cornerRadius = thumbnailImage.frame.height / 6
        setImage.layer.cornerRadius = setImage.frame.height / 2
        annotationLabel.layer.cornerRadius = setImage.frame.height / 2
        removeAnnotation()
        
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                                  object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeNotification(_:)),
                                               name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                               object: nil)
    }

    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override open func prepareForReuse() {
        thumbnailImage.image = ManaKit.sharedInstance.imageFromFramework(imageName: .cardBackCropped)
        symbolImage.image = nil
        removeAnnotation()
        nameLabel.text = nil
        castingCostLabel.text = nil
        typeLabel.text = nil
        setImage.text = nil
        updatePricing(nil)
    }
    
    // MARK: Custom methods
    open func updateDataDisplay() {
        guard let cardMID = cardMID,
            let card = ManaKit.sharedInstance.dataStack?.mainContext.object(with: cardMID) as? CMCard else {
            prepareForReuse()
            return
        }
        
        // name
        nameLabel.text = card.name
        if let releaseDate = card.set!.releaseDate {
            let isModern = ManaKit.sharedInstance.isModern(card)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            if let m15Date = formatter.date(from: "2014-07-18"),
                let setReleaseDate = formatter.date(from: releaseDate) {
                
                var shadowColor:UIColor?
                var shadowOffset = CGSize(width: 0, height: -1)
                
                if setReleaseDate.compare(m15Date) == .orderedSame ||
                    setReleaseDate.compare(m15Date) == .orderedDescending {
                    nameLabel.font = magic2015Font
                    
                } else {
                    nameLabel.font = isModern ? eightEditionFont : preEightEditionFont
                    
                    if !isModern {
                        shadowColor = UIColor.darkGray
                        shadowOffset = CGSize(width: 1, height: 1)
                    }
                }
                
                nameLabel.shadowColor = shadowColor
                nameLabel.shadowOffset = shadowOffset
            }
        }
        
        // casting cost
        if let manaCost = card.manaCost {
            let pointSize = castingCostLabel.font.pointSize
            castingCostLabel.attributedText = NSAttributedString(symbol: manaCost, pointSize: pointSize)
        } else {
            castingCostLabel.text = nil
        }
        
        // thumbnail image
        if let croppedImage = ManaKit.sharedInstance.croppedImage(card) {
            thumbnailImage.image = croppedImage
        } else {
            thumbnailImage.image = ManaKit.sharedInstance.imageFromFramework(imageName: .cardBackCropped)
            
            firstly {
                ManaKit.sharedInstance.downloadImage(ofCard: card, imageType: .artCrop)
            }.done {
                guard let image = ManaKit.sharedInstance.croppedImage(card) else {
                    return
                }
                
                let animations = {
                    self.thumbnailImage.image = image
                }
                UIView.transition(with: self.thumbnailImage,
                                  duration: 1.0,
                                  options: .transitionCrossDissolve,
                                  animations: animations,
                                  completion: nil)
            }.catch { error in
                
            }
        }
        
        // set symbol
        if let rarity = card.rarity_,
            let set = card.set {
            setImage.text = ManaKit.sharedInstance.keyruneUnicode(forSet: set)
            setImage.textColor = ManaKit.sharedInstance.keyruneColor(forRarity: rarity)
        }

        // type symbol
        var cardType: CMCardType?
        if let types = card.types_ {
            if types.count > 1 {
                symbolImage.image = ManaKit.sharedInstance.symbolImage(name: "Multiple")
                cardType = types.allObjects.first as? CMCardType
                
                for t in types.allObjects {
                    if let t = t as? CMCardType {
                        if t.name == "Creature" {
                            cardType = t
                        }
                    }
                }
            } else {
                if let type = types.allObjects.first as? CMCardType {
                    cardType = type
                }
            }
        }

        if let cardType = cardType {
            if let name = cardType.name {
                symbolImage.image = ManaKit.sharedInstance.symbolImage(name: name)
            }
        }
        
        // type
        if let type = card.type_,
            let cardType = cardType {
            var typeText = ""
            
            if let name = type.name {
                typeText.append(name)
            }
            if let name = cardType.name {
                if name == "Creature" {
                    if let power = card.power,
                        let toughness = card.toughness {
                        typeText.append(" (\(power)/\(toughness))")
                    }
                }
            }
            typeLabel.text = typeText
        }

        // pricing
        var willFetchPricing = false
        if let set = card.set {
            willFetchPricing = !set.onlineOnly
        }
        if willFetchPricing {
            firstly {
                ManaKit.sharedInstance.fetchTCGPlayerCardPricing(cardMID: card.objectID)
            }.done { (pricingMID: NSManagedObjectID?) in
                self.updatePricing(pricingMID)
            }.catch { error in
                self.updatePricing(nil)
            }
        } else {
            self.updatePricing(nil)
        }
    }
    
    open func add(annotation: Int) {
        annotationLabel.backgroundColor = UIColor.red
        annotationLabel.text = "\(annotation)"
    }
    
    open func removeAnnotation() {
        annotationLabel.backgroundColor = UIColor.clear
        annotationLabel.text = ""
    }
    
    open func updatePricing(_ pricingMID: NSManagedObjectID?) {
        if let pricingMID = pricingMID {
            guard let pricing = ManaKit.sharedInstance.dataStack?.mainContext.object(with: pricingMID) as? CMCardPricing else {
                lowPriceLabel.text = "NA"
                lowPriceLabel.textColor = normalColor
                
                midPriceLabel.text = "NA"
                midPriceLabel.textColor = normalColor
                
                highPriceLabel.text = "NA"
                highPriceLabel.textColor = normalColor
                
                foilPriceLabel.text = "NA"
                foilPriceLabel.textColor = normalColor
                return
            }
            
            lowPriceLabel.text = pricing.low > 0 ? String(format: "$%.2f", pricing.low) : "NA"
            lowPriceLabel.textColor = pricing.low > 0 ? lowPriceColor : normalColor
            
            midPriceLabel.text = pricing.average > 0 ? String(format: "$%.2f", pricing.average) : "NA"
            midPriceLabel.textColor = pricing.average > 0 ? midPriceColor : normalColor
            
            highPriceLabel.text = pricing.high > 0 ? String(format: "$%.2f", pricing.high) : "NA"
            highPriceLabel.textColor = pricing.high > 0 ? highPriceColor : normalColor
            
            foilPriceLabel.text = pricing.foil > 0 ? String(format: "$%.2f", pricing.foil) : "NA"
            foilPriceLabel.textColor = pricing.foil > 0 ? foilPriceColor : normalColor
        } else {
            lowPriceLabel.text = "NA"
            lowPriceLabel.textColor = normalColor
            
            midPriceLabel.text = "NA"
            midPriceLabel.textColor = normalColor
            
            highPriceLabel.text = "NA"
            highPriceLabel.textColor = normalColor
            
            foilPriceLabel.text = "NA"
            foilPriceLabel.textColor = normalColor
        }
    }
    
    // MARK: Core Data notifications
    func changeNotification(_ notification: Notification) {
        guard let cardMID = cardMID,
            let card = ManaKit.sharedInstance.dataStack?.mainContext.object(with: cardMID) as? CMCard else {
                return
        }
        
        if let updatedObjects = notification.userInfo?[NSUpdatedObjectsKey] {
            if let set = updatedObjects as? NSSet {
                for o in set.allObjects {
                    if let pricing = o as? CMCardPricing {
                        if pricing.card?.objectID == card.objectID {
                            updatePricing(pricing.objectID)
                        }
                    }
                }
            }
        }
    }
}

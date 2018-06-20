//
//  CardTableViewCell.swift
//  CardMagusKit
//
//  Created by Jovito Royeca on 15/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
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
    open var card:CMCard?
    
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
    }

    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override open func prepareForReuse() {
        thumbnailImage.image = UIImage(named: ImageName.cardBackCropped.rawValue)
        symbolImage.image = nil
        removeAnnotation()
        nameLabel.text = nil
        castingCostLabel.text = nil
        typeLabel.text = nil
        setImage.text = nil
        lowPriceLabel.text  = "NA"
        midPriceLabel.text  = "NA"
        highPriceLabel.text = "NA"
        foilPriceLabel.text = "NA"
    }
    
    // MARK: Custom methods
    open func updateDataDisplay() {
        guard let card = card else {
            prepareForReuse()
            return
        }
        
        // name and casting cost
        updateName()
        updateCastingCost()
        
        // thumbnail image and casting cost
        if let croppedImage = ManaKit.sharedInstance.croppedImage(card) {
            thumbnailImage.image = croppedImage
        } else {
            thumbnailImage.image = ManaKit.sharedInstance.imageFromFramework(imageName: .cardBackCropped)
            
            firstly {
                ManaKit.sharedInstance.downloadImage(ofCard: card, imageType: .artCrop)
            }.done { (image: UIImage?) in
                UIView.transition(with: self.thumbnailImage,
                                  duration: 0.5,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    self.thumbnailImage.image = image
                                  },
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
                ManaKit.sharedInstance.fetchTCGPlayerCardPricing(card: card)
            }.done { (pricing: CMCardPricing?) in
                if let pricing = pricing {
                    self.lowPriceLabel.text = pricing.low > 0 ? String(format: "$%.2f", pricing.low) : "NA"
                    self.lowPriceLabel.textColor = pricing.low > 0 ? self.lowPriceColor : self.normalColor
                    
                    self.midPriceLabel.text = pricing.average > 0 ? String(format: "$%.2f", pricing.average) : "NA"
                    self.midPriceLabel.textColor = pricing.average > 0 ? self.midPriceColor : self.normalColor
                    
                    self.highPriceLabel.text = pricing.high > 0 ? String(format: "$%.2f", pricing.high) : "NA"
                    self.highPriceLabel.textColor = pricing.high > 0 ? self.highPriceColor : self.normalColor
                    
                    self.foilPriceLabel.text = pricing.foil > 0 ? String(format: "$%.2f", pricing.foil) : "NA"
                    self.foilPriceLabel.textColor = pricing.foil > 0 ? self.foilPriceColor : self.normalColor
                }
            }.catch { error in
                self.lowPriceLabel.text = "NA"
                self.lowPriceLabel.textColor = self.normalColor
                
                self.midPriceLabel.text = "NA"
                self.midPriceLabel.textColor = self.normalColor
                
                self.highPriceLabel.text = "NA"
                self.highPriceLabel.textColor = self.normalColor
                
                self.foilPriceLabel.text = "NA"
                self.foilPriceLabel.textColor = self.normalColor
            }
        } else {
            self.lowPriceLabel.text = "NA"
            self.lowPriceLabel.textColor = normalColor
            
            self.midPriceLabel.text = "NA"
            self.midPriceLabel.textColor = normalColor
            
            self.highPriceLabel.text = "NA"
            self.highPriceLabel.textColor = normalColor
            
            self.foilPriceLabel.text = "NA"
            self.foilPriceLabel.textColor = normalColor
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
    
    open func updateName() {
        guard let card = card else {
            return
        }
        
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
    }
    
    open func updateCastingCost() {
        guard let card = card,
            let manaCost = card.manaCost else {
                castingCostLabel.text = nil
            return
        }
        
        let pointSize = castingCostLabel.font.pointSize
        let attributedString = NSAttributedString(string: manaCost)
        castingCostLabel.attributedText =  attributedString.addSymbols(pointSize: pointSize)
    }
}

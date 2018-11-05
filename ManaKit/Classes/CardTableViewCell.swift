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

public class CardTableViewCell: UITableViewCell {
    public static let reuseIdentifier = "CardCell"
    public static let cellHeight = CGFloat(88)
    
    // Variables
    public var card: CMCard? {
        didSet {
            updateDataDisplay()
        }
    }
    
    // MARK: Outlets
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var castingCostLabel: UILabel!
    @IBOutlet weak var annotationLabel: UILabel!
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var setImage: UILabel!
    @IBOutlet weak var lowPriceLabel: UILabel!
    @IBOutlet weak var midPriceLabel: UILabel!
    @IBOutlet weak var highPriceLabel: UILabel!
    @IBOutlet weak var foilPriceLabel: UILabel!

    // MARK: Overrides
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // add round corners
        thumbnailImage.layer.cornerRadius = thumbnailImage.frame.height / 6
        setImage.layer.cornerRadius = setImage.frame.height / 2
        annotationLabel.layer.cornerRadius = setImage.frame.height / 2
        removeAnnotation()
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Custom methods
    public func clearDataDisplay() {
        thumbnailImage.image = ManaKit.sharedInstance.imageFromFramework(imageName: .cardBackCropped)
        typeImage.image = nil
        removeAnnotation()
        nameLabel.text = nil
        castingCostLabel.text = nil
        typeLabel.text = nil
        setImage.text = nil
        
        lowPriceLabel.text = "NA"
        lowPriceLabel.textColor = ManaKit.PriceColors.normal
        
        midPriceLabel.text = "NA"
        midPriceLabel.textColor = ManaKit.PriceColors.normal
        
        highPriceLabel.text = "NA"
        highPriceLabel.textColor = ManaKit.PriceColors.normal
        
        foilPriceLabel.text = "NA"
        foilPriceLabel.textColor = ManaKit.PriceColors.normal
    }
    
    private func updateDataDisplay() {
        guard let card = card else {
            clearDataDisplay()
            return
        }
        
        // name
        nameLabel.text = ManaKit.sharedInstance.name(ofCard: card)
        
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
                    nameLabel.font = ManaKit.Fonts.magic2015
                    
                } else {
                    nameLabel.font = isModern ? ManaKit.Fonts.eightEdition : ManaKit.Fonts.preEightEdition
                    
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
        if let set = card.set {
            setImage.text = ManaKit.sharedInstance.keyruneUnicode(forSet: set)
            setImage.textColor = ManaKit.sharedInstance.keyruneColor(forCard: card)
        }

        // type
        typeImage.image = ManaKit.sharedInstance.typeImage(ofCard: card)
        typeLabel.text = ManaKit.sharedInstance.typeText(ofCard: card)
        
        // pricing
        var willFetchPricing = false
        if let set = card.set {
            willFetchPricing = !set.isOnlineOnly
        }
        if willFetchPricing {
            firstly {
                ManaKit.sharedInstance.fetchTCGPlayerCardPricing(card: card)
            }.done {
                self.updatePricing()
            }.catch { error in
                self.updatePricing()
            }
        } else {
            updatePricing()
        }
    }
    
    public func add(annotation: Int) {
        annotationLabel.backgroundColor = UIColor.red
        annotationLabel.text = "\(annotation)"
    }
    
    public func removeAnnotation() {
        annotationLabel.backgroundColor = UIColor.clear
        annotationLabel.text = ""
    }
    
    public func updatePricing() {
        guard let card = card,
            let pricing = card.pricing else {
                lowPriceLabel.text = "NA"
                lowPriceLabel.textColor = ManaKit.PriceColors.normal
                
                midPriceLabel.text = "NA"
                midPriceLabel.textColor = ManaKit.PriceColors.normal
                
                highPriceLabel.text = "NA"
                highPriceLabel.textColor = ManaKit.PriceColors.normal
                
                foilPriceLabel.text = "NA"
                foilPriceLabel.textColor = ManaKit.PriceColors.normal
                return
        }
        
        lowPriceLabel.text = pricing.low > 0 ? String(format: "$%.2f", pricing.low) : "NA"
        lowPriceLabel.textColor = pricing.low > 0 ? ManaKit.PriceColors.low : ManaKit.PriceColors.normal
        
        midPriceLabel.text = pricing.average > 0 ? String(format: "$%.2f", pricing.average) : "NA"
        midPriceLabel.textColor = pricing.average > 0 ? ManaKit.PriceColors.mid : ManaKit.PriceColors.normal
        
        highPriceLabel.text = pricing.high > 0 ? String(format: "$%.2f", pricing.high) : "NA"
        highPriceLabel.textColor = pricing.high > 0 ? ManaKit.PriceColors.high : ManaKit.PriceColors.normal
        
        foilPriceLabel.text = pricing.foil > 0 ? String(format: "$%.2f", pricing.foil) : "NA"
        foilPriceLabel.textColor = pricing.foil > 0 ? ManaKit.PriceColors.foil : ManaKit.PriceColors.normal
    }
}

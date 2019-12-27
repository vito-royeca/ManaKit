//
//  CardTableViewCell.swift
//  CardMagusKit
//
//  Created by Jovito Royeca on 15/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import PromiseKit

public class CardTableViewCell: UITableViewCell {
    public static let reuseIdentifier = "CardCell"
    public static let cellHeight = CGFloat(88)
    
    // Variables
    public var card: MGCard?
    public var faceOrder = 0
    
    var nameAttributedString: NSAttributedString?
//    var manaCostDisplayed = false
    
    // MARK: Outlets
    @IBOutlet public weak var thumbnailImage: UIImageView!
    @IBOutlet public weak var nameLabel: UILabel!
    @IBOutlet public weak var castingCostLabel: UILabel!
    @IBOutlet public weak var castingCostLabel2: UILabel!
    @IBOutlet public weak var annotationLabel: UILabel!
    @IBOutlet public weak var typeImage: UIImageView!
    @IBOutlet public weak var typeLabel: UILabel!
    @IBOutlet public weak var setImage: UILabel!
    @IBOutlet public weak var normalPriceLabel: UILabel!
    @IBOutlet public weak var foilPriceLabel: UILabel!
    @IBOutlet public weak var nameView: UIView!
    @IBOutlet public weak var typeView: UIView!
    
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
        castingCostLabel2.text = nil
        typeLabel.text = nil
        setImage.text = nil
        normalPriceLabel.text = "NA"
        foilPriceLabel.text = "NA"
    }
    
    public func updateDataDisplay() {
        guard let card = card else {
            clearDataDisplay()
            return
        }
        
        // name
        if let releaseDate = card.set!.releaseDate {
            let isModern = card.isModern()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            var font: UIFont?
            
            if let m15Date = formatter.date(from: "2014-07-18"),
                let setReleaseDate = formatter.date(from: releaseDate) {
                
                var shadowColor:UIColor?
                var shadowOffset = CGSize(width: 0, height: -1)
                
                if setReleaseDate.compare(m15Date) == .orderedSame ||
                    setReleaseDate.compare(m15Date) == .orderedDescending {
                    font = ManaKit.Fonts.magic2015
                    
                } else {
                    font = isModern ? ManaKit.Fonts.eightEdition : ManaKit.Fonts.preEightEdition
                    
                    if !isModern {
                        shadowColor = UIColor.darkGray
                        shadowOffset = CGSize(width: 1, height: 1)
                    }
                }
                
                nameLabel.shadowColor = shadowColor
                nameLabel.shadowOffset = shadowOffset
            }
            
            if let name = card.displayName,
                let font = font {
                let attributes = [NSAttributedString.Key.font: font]
                nameAttributedString = NSAttributedString(string: name, attributes: attributes)
            }
        }
        nameLabel.attributedText = nameAttributedString
        castingCostLabel.text = nil
        castingCostLabel2.text = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.displayManaCost()
        }
        
        // thumbnail image
        if let croppedImage = card.image(type: .artCrop,
                                         faceOrder: faceOrder,
                                         roundCornered: false) {
            thumbnailImage.image = croppedImage
        } else {
            thumbnailImage.image = ManaKit.sharedInstance.imageFromFramework(imageName: .cardBackCropped)

            firstly {
                ManaKit.sharedInstance.downloadImage(ofCard: card,
                                                     type: .artCrop,
                                                     faceOrder: faceOrder)
            }.done {
                guard let image = card.image(type: .artCrop,
                                             faceOrder: self.faceOrder,
                                             roundCornered: false) else {
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
            setImage.text = set.keyruneUnicode()
            setImage.textColor = card.keyruneColor()
        }

        // type
        typeImage.image = card.typeImage()
        typeLabel.text = card.typeText(includePower: true)
        
        // pricing
        updateCardPricing()
    }
    
    public func displayManaCost() {
        guard let card = card else {
            clearDataDisplay()
            return
        }
        
        var castingCostAttributedString: NSAttributedString?

        if let manaCost = card.manaCost {
            let pointSize = castingCostLabel.font.pointSize
            castingCostAttributedString = NSAttributedString(symbol: manaCost, pointSize: pointSize)
        }
        
        if let nameAttributedString = nameAttributedString,
            let castingCostAttributedString = castingCostAttributedString {
            let nameSize = sizeOf(attributedString: nameAttributedString, withFrameSize: nameLabel.frame.size)
            let ccSize = castingCostAttributedString.widthOf(symbol: card.manaCost!)
            
            if  (nameSize.width + ccSize) > nameLabel.frame.size.width {
                castingCostLabel.text = nil
                castingCostLabel2.attributedText = castingCostAttributedString
            } else {
                castingCostLabel.attributedText = castingCostAttributedString
                castingCostLabel2.text = nil
                typeView.topAnchor.constraint(equalTo: nameView.bottomAnchor, constant: 8).isActive = true
            }
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
    
    private func updateCardPricing() {
        foilPriceLabel.text = "NA"
        normalPriceLabel.text = "NA"

        guard let card = card else {
            return
        }
        
//        for pricing in card.pricings {
//            if pricing.isFoil {
//                foilPriceLabel.text = pricing.marketPrice > 0 ? String(format: "$%.2f", pricing.marketPrice) : "NA"
//            } else {
//                normalPriceLabel.text = pricing.marketPrice > 0 ? String(format: "$%.2f", pricing.marketPrice) : "NA"
//            }
//        }
    }
    
    private func sizeOf(attributedString: NSAttributedString, withFrameSize frameSize: CGSize) -> CGSize {
        return attributedString.boundingRect(with: frameSize,
                                             options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                             context: nil).size
    }
}

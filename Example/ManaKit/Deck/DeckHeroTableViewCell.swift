//
//  DeckHeroTableViewCell.swift
//  ManaKit_Example
//
//  Created by Jovito Royeca on 07.09.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import ManaKit
import PromiseKit

class DeckHeroTableViewCell: UITableViewCell {
    static let reuseIdentifier = "HeroCell"
    
    // MARK: Outlets
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var formatLabel: UILabel!

    // MARK: Variables
    var deck: CMDeck! {
        didSet {
            // thumbnail image
            nameLabel.text = deck.name
            formatLabel.text = deck.format?.name
            
            guard let heroCard = deck.heroCard else {
                heroImageView.image = ManaKit.sharedInstance.imageFromFramework(imageName: .cardBackCropped)
                return
            }
            
            if let croppedImage = ManaKit.sharedInstance.croppedImage(heroCard) {
                heroImageView.image = croppedImage
            } else {
                heroImageView.image = ManaKit.sharedInstance.imageFromFramework(imageName: .cardBackCropped)
                
                firstly {
                    ManaKit.sharedInstance.downloadImage(ofCard: heroCard, imageType: .artCrop)
                }.done {
                    guard let image = ManaKit.sharedInstance.croppedImage(heroCard) else {
                        return
                    }
                    
                    let animations = {
                        self.heroImageView.image = image
                    }
                    UIView.transition(with: self.heroImageView,
                                      duration: 1.0,
                                      options: .transitionCrossDissolve,
                                      animations: animations,
                                      completion: nil)
                }.catch { error in
                        
                }
            }
        }
    }
    
    // MARK: Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

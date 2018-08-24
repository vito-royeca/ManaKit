//
//  DeckTableViewCell.swift
//  ManaKit
//
//  Created by Jovito Royeca on 23.08.18.
//

import UIKit
import PromiseKit

public class DeckTableViewCell: UITableViewCell {
    public static let reuseIdentifier = "DeckCell"
    
    // Variables
    public var deck: CMDeck? {
        didSet {
            updateDataDisplay()
        }
    }
    
    // MARK: Outlets
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var formatLabel: UILabel!
    @IBOutlet weak var colorsLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    
    
    // MARK: Overrides
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbnailImage.layer.cornerRadius = thumbnailImage.frame.height / 6
        userImage.layer.cornerRadius = userImage.frame.height / 2
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Custom methods
    public func clearDataDisplay() {
        thumbnailImage.image = ManaKit.sharedInstance.imageFromFramework(imageName: .cardBackCropped)
        nameLabel.text = nil
        colorsLabel.text = nil
        formatLabel.text = nil
    }
    
    private func updateDataDisplay() {
        guard let deck = deck else {
            clearDataDisplay()
            return
        }
    
        // thumbnail image
        if let card = deck.heroCard {
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
        } else {
            thumbnailImage.image = ManaKit.sharedInstance.imageFromFramework(imageName: .cardBackCropped)
        }
        
        // name
        nameLabel.text = deck.name
        
        // casting cost
        if let colors = deck.colors {
            let pointSize = colorsLabel.font.pointSize
            colorsLabel.attributedText = NSAttributedString(symbol: colors, pointSize: pointSize)
        } else {
            colorsLabel.text = nil
        }
        
        // format
        if let format = deck.format {
            formatLabel.text = format.name
        } else {
            formatLabel.text = nil
        }
        
        // user
        if let user = deck.user {
            // TODO: handle user avatar
            userImage.image = nil
            displayNameLabel.text = user.displayName
        } else {
            userImage.image = nil
            displayNameLabel.text = nil
        }
    }
}

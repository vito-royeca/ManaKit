//
//  DeckHeroTableViewCell.swift
//  ManaKit_Example
//
//  Created by Jovito Royeca on 07.09.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import ManaKit

class DeckHeroTableViewCell: UITableViewCell {
    static let reuseIdentifier = "heroCell"
    
    // MARK: Outlets
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var formatLabel: UILabel!

    // MARK: Variables
    var deck: CMDeck! {
        didSet {
            nameLabel.text = deck.name
            formatLabel.text = deck.format?.name
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

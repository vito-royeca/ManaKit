//
//  SetsTableViewCell.swift
//  ManaKit
//
//  Created by Jovito Royeca on 16.08.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import ManaKit

class SetsTableViewCell: UITableViewCell {

    static let reuseIdentifier = "SetsCell"
    
    // MARK: Outlets
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!

    // MARK: Variables
    var set: CMSet! {
        didSet {
            logoLabel.text = ManaKit.sharedInstance.keyruneUnicode(forSet: set)
            nameLabel.text = set.name
            var codeText = "\(set.parent != nil ? "\(set.parent!.code!) <-- " : "")\(set.code!)"
            if let tcgplayerName = set.tcgplayerName {
               codeText = "\(codeText) / TCGPlayerName = \(tcgplayerName)"
            } else {
               codeText = "\(codeText) / TCGPlayerName = nil"
            }
            codeLabel.text = codeText
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

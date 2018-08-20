//
//  SetTableViewCell.swift
//  ManaKit
//
//  Created by Jovito Royeca on 16.08.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class SetTableViewCell: UITableViewCell {

    static let reuseIdentifier = "SetCell"
    
    @IBOutlet weak var setLogo: UILabel!
    @IBOutlet weak var setName: UILabel!
    @IBOutlet weak var setCode: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

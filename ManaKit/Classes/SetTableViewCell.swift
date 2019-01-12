//
//  SetTableViewCell.swift
//  ManaKit
//
//  Created by Jovito Royeca on 01/01/2019.
//

import UIKit

public protocol SetTableViewCellDelegate: NSObjectProtocol {
    func languageAction(cell: UITableViewCell, code: String)
}

public class SetTableViewCell: UITableViewCell {

    public static let reuseIdentifier = "SetCell"
    public static let cellHeight = CGFloat(114)
    
    // MARK: Outlets
    @IBOutlet public weak var logoLabel: UILabel!
    @IBOutlet public weak var nameLabel: UILabel!
    @IBOutlet public weak var codeLabel: UILabel!
    @IBOutlet public weak var releaseDateLabel: UILabel!
    @IBOutlet public weak var numberLabel: UILabel!
    @IBOutlet public weak var enButton: UIButton!
    @IBOutlet public weak var esButton: UIButton!
    @IBOutlet public weak var frButton: UIButton!
    @IBOutlet public weak var deButton: UIButton!
    @IBOutlet public weak var itButton: UIButton!
    @IBOutlet public weak var ptButton: UIButton!
    @IBOutlet public weak var jaButton: UIButton!
    @IBOutlet public weak var koButton: UIButton!
    @IBOutlet public weak var ruButton: UIButton!
    @IBOutlet public weak var zhsButton: UIButton!
    @IBOutlet public weak var zhtButton: UIButton!
    @IBOutlet public weak var blankButton: UIButton!

    // MARK: Actions
    @IBAction public func languageAction(_ sender: UIButton) {
        var code = ""
        
        if sender == enButton {
            code = "en"
        } else if sender == esButton {
            code = "es"
        } else if sender == frButton {
            code = "fr"
        } else if sender == deButton {
            code = "de"
        } else if sender == itButton {
            code = "it"
        } else if sender == ptButton {
            code = "pt"
        } else if sender == jaButton {
            code = "ja"
        } else if sender == koButton {
            code = "ko"
        } else if sender == ruButton {
            code = "ru"
        } else if sender == zhsButton {
            code = "zhs"
        } else if sender == zhtButton {
            code = "zht"
        }
        
        delegate?.languageAction(cell: self, code: code)
    }
    
    // MARK: Variables
    public var set: CMSet! {
        didSet {
            logoLabel.text = set.keyruneUnicode()
            nameLabel.text = set.name
            codeLabel.text = set.code
            releaseDateLabel.text = set.releaseDate ?? " "
            numberLabel.text = "\(set.cardCount) cards"
            
            enButton.isEnabled = false
            esButton.isEnabled = false
            frButton.isEnabled = false
            deButton.isEnabled = false
            itButton.isEnabled = false
            ptButton.isEnabled = false
            jaButton.isEnabled = false
            koButton.isEnabled = false
            ruButton.isEnabled = false
            zhsButton.isEnabled = false
            zhtButton.isEnabled = false
            
            for language in set.languages {
                if language.code == "en" {
                    enButton.isEnabled = true
                } else if language.code == "es" {
                    esButton.isEnabled = true
                } else if language.code == "fr" {
                    frButton.isEnabled = true
                } else if language.code == "de" {
                    deButton.isEnabled = true
                } else if language.code == "it" {
                    itButton.isEnabled = true
                } else if language.code == "pt" {
                    ptButton.isEnabled = true
                } else if language.code == "ja" {
                    jaButton.isEnabled = true
                } else if language.code == "ko" {
                    koButton.isEnabled = true
                } else if language.code == "ru" {
                    ruButton.isEnabled = true
                } else if language.code == "zhs" {
                    zhsButton.isEnabled = true
                } else if language.code == "zht" {
                    zhtButton.isEnabled = true
                }
            }
            
        }
    }
    public var delegate: SetTableViewCellDelegate?
    
    // MARK: Overrides
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        enButton.setBackgroundColor(LookAndFeel.GlobalTintColor, for: .normal)
//        enButton.setBackgroundColor(UIColor.lightGray, for: .disabled)
        
//        esButton.setBackgroundColor(LookAndFeel.GlobalTintColor, for: .normal)
//        esButton.setBackgroundColor(UIColor.lightGray, for: .disabled)
        
//        frButton.setBackgroundColor(LookAndFeel.GlobalTintColor, for: .normal)
//        frButton.setBackgroundColor(UIColor.lightGray, for: .disabled)
        
//        deButton.setBackgroundColor(LookAndFeel.GlobalTintColor, for: .normal)
//        deButton.setBackgroundColor(UIColor.lightGray, for: .disabled)
        
//        itButton.setBackgroundColor(LookAndFeel.GlobalTintColor, for: .normal)
//        itButton.setBackgroundColor(UIColor.lightGray, for: .disabled)
        
//        ptButton.setBackgroundColor(LookAndFeel.GlobalTintColor, for: .normal)
//        ptButton.setBackgroundColor(UIColor.lightGray, for: .disabled)
        
//        jaButton.setBackgroundColor(LookAndFeel.GlobalTintColor, for: .normal)
//        jaButton.setBackgroundColor(UIColor.lightGray, for: .disabled)
        
//        koButton.setBackgroundColor(LookAndFeel.GlobalTintColor, for: .normal)
//        koButton.setBackgroundColor(UIColor.lightGray, for: .disabled)
        
//        ruButton.setBackgroundColor(LookAndFeel.GlobalTintColor, for: .normal)
//        ruButton.setBackgroundColor(UIColor.lightGray, for: .disabled)
        
//        zhsButton.setBackgroundColor(LookAndFeel.GlobalTintColor, for: .normal)
//        zhsButton.setBackgroundColor(UIColor.lightGray, for: .disabled)
        
//        zhtButton.setBackgroundColor(LookAndFeel.GlobalTintColor, for: .normal)
//        zhtButton.setBackgroundColor(UIColor.lightGray, for: .disabled)
        
//        blankButton.setBackgroundColor(UIColor.lightGray, for: .disabled)
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

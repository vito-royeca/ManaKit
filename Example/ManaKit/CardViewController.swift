//
//  CardViewController.swift
//  ManaKit
//
//  Created by Jovito Royeca on 28/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import CoreData
import ManaKit
import PromiseKit

class CardViewController: UIViewController {

    // MARK: Variables
    var card: CMCard?
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(ManaKit.sharedInstance.nibFromBundle("CardTableViewCell"), forCellReuseIdentifier: "CardCell")
    }
}

// MARK: UITableViewDataSource
extension CardViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        
        switch indexPath.row {
        case 0:
            guard let c = tableView.dequeueReusableCell(withIdentifier: "CardCell") as? CardTableViewCell,
                let card = card else {
                return UITableViewCell(frame: CGRect.zero)
            }
            
            c.card = card
            c.updateDataDisplay()
            cell = c
            
        case 1:
            guard let c = tableView.dequeueReusableCell(withIdentifier: "ImageCell"),
                let imageView = c.viewWithTag(100) as? UIImageView,
                let card = card else {
                return UITableViewCell(frame: CGRect.zero)
            }
            
            if let cardImage = ManaKit.sharedInstance.cardImage(card, imageType: .normal) {
                imageView.image = cardImage
            } else {
                imageView.image = ManaKit.sharedInstance.cardBack(card)

                firstly {
                    ManaKit.sharedInstance.downloadImage(ofCard: card, imageType: .normal)
                }.done {
                    guard let image = ManaKit.sharedInstance.cardImage(card, imageType: .normal) else {
                        return
                    }
                    
                    let animations = {
                        imageView.image = image
                    }
                    UIView.transition(with: imageView,
                                      duration: 1.0,
                                      options: .transitionFlipFromRight,
                                      animations: animations,
                                      completion: nil)
                }.catch { error in
                    
                }
            }
                
            cell = c
            
        default:
            ()
        }
        
        return cell!
    }
}

// MARK: UITableViewDelegate
extension CardViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = CGFloat(0)
        
        switch indexPath.row {
        case 0:
            height = kCardTableViewCellHeight
        case 1:
            height = tableView.frame.size.height - kCardTableViewCellHeight
        default:
            height = UITableViewAutomaticDimension
        }
        
        return height
    }
}

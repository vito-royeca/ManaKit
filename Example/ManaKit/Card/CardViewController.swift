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
    var card: CMCard!
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(ManaKit.sharedInstance.nibFromBundle("CardTableViewCell"), forCellReuseIdentifier: "CardCell")
        title = ManaKit.sharedInstance.name(ofCard: card)
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
            guard let c = tableView.dequeueReusableCell(withIdentifier: "CardCell") as? CardTableViewCell else {
                fatalError("Unexpected indexPath: \(indexPath)")
            }
            
            c.card = card
            cell = c
            
        case 1:
            guard let c = tableView.dequeueReusableCell(withIdentifier: "ImageCell"),
                let imageView = c.viewWithTag(100) as? UIImageView else {
                fatalError("Unexpected indexPath: \(indexPath)")
            }
            
            if let cardImage = ManaKit.sharedInstance.cardImage(card, imageType: .normal) {
                imageView.image = cardImage
            } else {
                imageView.image = ManaKit.sharedInstance.cardBack(card)

                firstly {
                    ManaKit.sharedInstance.downloadImage(ofCard: card, imageType: .normal)
                }.done {
                    guard let image = ManaKit.sharedInstance.cardImage(self.card, imageType: .normal) else {
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
                    print("\(error)")
                }
            }
                
            cell = c
            
        default:
            cell = UITableViewCell(frame: CGRect.zero)
        }
        
        if let rulingsSet = card.cardRulings,
            let rulings = rulingsSet.allObjects as? [CMCardRuling] {
            print("\(card.set!.code!) - \(card.name!) - \(card.id!)")
            for ruling in rulings {
                print("\t\(ruling.ruling!.date!) - \(ruling.ruling!.text!)")
            }
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
            height = CardTableViewCell.cellHeight
        case 1:
            height = tableView.frame.size.height - CardTableViewCell.cellHeight
        default:
            height = UITableView.automaticDimension
        }
        
        return height
    }
}

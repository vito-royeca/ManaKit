//
//  CardViewController.swift
//  ManaKit
//
//  Created by Jovito Royeca on 28/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import CoreData
import FontAwesome_swift
import ManaKit
import PromiseKit

class CardViewController: BaseViewController {
    // MARK: Variables
    var faceOrder = 0
    var flipAngle = CGFloat(0)

    // MARK: overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(ManaKit.sharedInstance.nibFromBundle("CardTableViewCell"), forCellReuseIdentifier: "CardCell")
    }
    
    // MARK: Custom methods
    @objc func buttonAction() {
        guard let card = viewModel.allObjects()?.first as? MGCard,
            let layout = card.layout,
            let layoutName = layout.name else {
            fatalError("Missing card layout")
        }
        
        if layoutName == "Double faced token" ||
            layoutName == "Transform" {
            
            if let faces = card.faces {
                let orderedFaces = faces.sorted(by: {(a, b) -> Bool in
                    if let a = a as? MGCard,
                        let b = b as? MGCard {
                        return a.faceOrder < b.faceOrder
                    } else {
                        return false
                    }
                })
                
                let count = orderedFaces.count
                
                if (faceOrder + 1) >= count {
                    faceOrder = 0
                } else {
                    faceOrder += 1
                }
            }
        } else if layoutName == "Flip" {
            flipAngle = flipAngle == 0 ? CGFloat(180 * Double.pi / 180) : 0
        } else if layoutName == "Planar" {
            flipAngle = flipAngle == 0 ? CGFloat(90 * Double.pi / 180) : 0
        }
        
        tableView.reloadData()
    }
}

// MARK: UITableViewDataSource
extension CardViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        
        guard let card = viewModel.allObjects()?.first as? MGCard else {
            return UITableViewCell(frame: CGRect.zero)
        }
        
        switch indexPath.row {
        case 0:
            guard let c = tableView.dequeueReusableCell(withIdentifier: "CardCell") as? CardTableViewCell else {
                fatalError("Unexpected indexPath: \(indexPath)")
            }
            
            c.faceOrder = faceOrder
            c.card = card
            c.updateDataDisplay()
            cell = c
            
        case 1:
            guard let c = tableView.dequeueReusableCell(withIdentifier: "ImageCell"),
                let imageView = c.viewWithTag(100) as? UIImageView,
                let button = c.viewWithTag(200) as? UIButton else {
                fatalError("Unexpected indexPath: \(indexPath)")
            }
            
            if let layout = card.layout,
                let layoutName = layout.name {
            
                button.layer.cornerRadius = button.frame.height / 2
                button.setTitle(nil, for: .normal)
                button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                
                if layoutName == "Double faced token" ||
                    layoutName == "Transform" {
                    button.isHidden = false
                    button.setImage(UIImage.fontAwesomeIcon(name: .sync,
                                                            style: .solid,
                                                            textColor: UIColor.white,
                                                            size: CGSize(width: 30, height: 30)),
                                    for: .normal)
                } else if layoutName == "Flip" ||
                    layoutName == "Planar" {
                    button.isHidden = false
                    button.setImage(UIImage.fontAwesomeIcon(name: .redo,
                                                            style: .solid,
                                                            textColor: UIColor.white,
                                                            size: CGSize(width: 30, height: 30)),
                                    for: .normal)
                } else {
                    button.isHidden = true
                }
            } else {
                button.isHidden = true
            }
            
            if let cardImage = card.image(type: .normal,
                                          faceOrder: faceOrder,
                                          roundCornered: true) {
                imageView.image = cardImage
                UIView.animate(withDuration: 1.0, animations: {
                    imageView.transform = CGAffineTransform(rotationAngle: self.flipAngle)
                })
            } else {
                imageView.image = card.backImage()

                firstly {
                    ManaKit.sharedInstance.downloadImage(ofCard: card,
                                                         type: .normal,
                                                         faceOrder: faceOrder)
                }.done {
                    guard let image = card.image(type: .normal,
                                                 faceOrder: self.faceOrder,
                                                 roundCornered: true) else {
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
        
        cell!.selectionStyle = .none
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

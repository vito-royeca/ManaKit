//
//  SetViewController.swift
//  ManaKit
//
//  Created by Jovito Royeca on 15/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import ManaKit
import DATASource

class SetViewController: UIViewController {

    // MARK: Variables
    var set:CMSet?
    var dataSource: DATASource?
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(ManaKit.sharedInstance.nibFromBundle("CardTableViewCell"), forCellReuseIdentifier: "CardCell")
        
        dataSource = getDataSource(nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCard" {
            if let dest = segue.destination as? CardViewController,
                let card = sender as? CMCard {
                    dest.card = card
            }
        }
    }

    // MARK: Custom methods
    func getDataSource(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>?) -> DATASource? {
        var request:NSFetchRequest<NSFetchRequestResult>?
        
        if let fetchRequest = fetchRequest {
            request = fetchRequest
        } else {
            request = NSFetchRequest(entityName: "CMCard")
            request!.predicate = NSPredicate(format: "set.code = %@", set!.code!)
            request!.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true),
                                        NSSortDescriptor(key: "number", ascending: true),
                                        NSSortDescriptor(key: "mciNumber", ascending: true)]
        }
        
        let dataSource = DATASource(tableView: tableView, cellIdentifier: "CardCell", fetchRequest: request!, mainContext: ManaKit.sharedInstance.dataStack!.mainContext, configuration: { cell, item, indexPath in
            if let card = item as? CMCard,
                let cardCell = cell as? CardTableViewCell {
                
                cardCell.card = card
                cardCell.updateDataDisplay()
            }
        })
        
        return dataSource
    }
}

// MARK: UITableViewDelegate
extension SetViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cards = dataSource!.all()
        let card = cards[indexPath.row]
        performSegue(withIdentifier: "showCard", sender: card)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kCardTableViewCellHeight
    }
}



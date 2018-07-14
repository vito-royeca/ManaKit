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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if dataSource == nil {
            dataSource = getDataSource()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCard" {
            guard let dest = segue.destination as? CardViewController,
                let card = sender as? CMCard else {
                return
            }
            
            dest.card = card
        }
    }

    // MARK: Custom methods
    func getDataSource() -> DATASource? {
        guard let set = set,
            let code = set.code else {
            return nil
        }
        
        let request = CMCard.fetchRequest()
        request.predicate = NSPredicate(format: "set.code = %@", code)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true),
                                   NSSortDescriptor(key: "number", ascending: true),
                                   NSSortDescriptor(key: "mciNumber", ascending: true)]
        
        let ds = DATASource(tableView: tableView,
                            cellIdentifier: "CardCell",
                            fetchRequest: request,
                            mainContext: ManaKit.sharedInstance.dataStack!.mainContext)
        ds.delegate = self
        
        return ds
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

// MARK: DATASourceDelegate
extension SetViewController : DATASourceDelegate {
    func dataSource(_ dataSource: DATASource, configureTableViewCell cell: UITableViewCell, withItem item: NSManagedObject, atIndexPath indexPath: IndexPath) {
        guard let card = item as? CMCard,
            let cardCell = cell as? CardTableViewCell else {
                return
        }
        
        cardCell.card = card
    }
}



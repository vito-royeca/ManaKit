//
//  SetViewController.swift
//  ManaKit
//
//  Created by Jovito Royeca on 15/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import CoreData
import ManaKit

class SetViewController: UIViewController {

    // MARK: Variables
    var set:CMSet?
    var fetchedResultsController: NSFetchedResultsController<CMCard>?
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchedResultsController = getFetchedResultsController(with: nil)
        tableView.register(ManaKit.sharedInstance.nibFromBundle("CardTableViewCell"), forCellReuseIdentifier: "CardCell")
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
    func getFetchedResultsController(with fetchRequest: NSFetchRequest<CMCard>?) -> NSFetchedResultsController<CMCard> {
        guard let set = set,
            let code = set.code else {
            fatalError("Set is nil")
        }
        
        let context = ManaKit.sharedInstance.dataStack!.viewContext
        var request: NSFetchRequest<CMCard>?
        
        if let fetchRequest = fetchRequest {
            request = fetchRequest
        } else {
            // create a default fetchRequest
            request = CMCard.fetchRequest() as? NSFetchRequest<CMCard>
            request!.predicate = NSPredicate(format: "set.code = %@", code)
            request!.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true),
                                       NSSortDescriptor(key: "number", ascending: true),
                                       NSSortDescriptor(key: "mciNumber", ascending: true)]
        }
        
        // Create Fetched Results Controller
        let frc = NSFetchedResultsController(fetchRequest: request!,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        
        // Configure Fetched Results Controller
        frc.delegate = self
        
        // perform fetch
        do {
            try frc.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        return frc
    }
}

// MARK: UITableViewDataSource
extension SetViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let fetchedResultsController = fetchedResultsController,
            let cards = fetchedResultsController.fetchedObjects else {
                return 0
        }
        
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let fetchedResultsController = fetchedResultsController,
            let cell = tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.reuseIdentifier,
                                                     for: indexPath) as? CardTableViewCell else {
            fatalError("Unexpected indexPath: \(indexPath)")
        }
        
        let card = fetchedResultsController.object(at: indexPath)
        
        // Configure Cell
        cell.card = card
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension SetViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let fetchedResultsController = fetchedResultsController else {
            return
        }
        
        let card = fetchedResultsController.object(at: indexPath)
        performSegue(withIdentifier: "showCard", sender: card)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kCardTableViewCellHeight
    }
}

// MARK: NSFetchedResultsControllerDelegate
extension SetViewController : NSFetchedResultsControllerDelegate {
    
}


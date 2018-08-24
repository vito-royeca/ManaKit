//
//  DeckViewController.swift
//  ManaKit_Example
//
//  Created by Jovito Royeca on 24.08.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import CoreData
import ManaKit

class DeckViewController: UIViewController {

    // MARK: Variables
    var deck: CMDeck?
    var fetchedResultsController: NSFetchedResultsController<CMCardInventory>?
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchedResultsController = getFetchedResultsController(with: nil)
        tableView.register(ManaKit.sharedInstance.nibFromBundle("CardTableViewCell"), forCellReuseIdentifier: CardTableViewCell.reuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Custom methods
    func getFetchedResultsController(with fetchRequest: NSFetchRequest<CMCardInventory>?) -> NSFetchedResultsController<CMCardInventory> {
        guard let deck = deck else {
            fatalError("Set is nil")
        }
        
        let context = ManaKit.sharedInstance.dataStack!.viewContext
        var request: NSFetchRequest<CMCardInventory>?
        
        if let fetchRequest = fetchRequest {
            request = fetchRequest
        } else {
            // create a default fetchRequest
            request = CMCardInventory.fetchRequest()
            request!.predicate = NSPredicate(format: "deck = %@", deck)
            request!.sortDescriptors = [NSSortDescriptor(key: "card.name", ascending: true)]
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
extension DeckViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let fetchedResultsController = fetchedResultsController,
            let cardInventories = fetchedResultsController.fetchedObjects else {
                return 0
        }
        
        return cardInventories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let fetchedResultsController = fetchedResultsController,
            let cell = tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.reuseIdentifier,
                                                     for: indexPath) as? CardTableViewCell else {
                                                        fatalError("Unexpected indexPath: \(indexPath)")
        }
        
        let cardInventory = fetchedResultsController.object(at: indexPath)
        
        // Configure Cell
        cell.card = cardInventory.card
        cell.add(annotation: Int(cardInventory.quantity))

        return cell
    }
}

// MARK: UITableViewDelegate
extension DeckViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kCardTableViewCellHeight
    }
}

// MARK: NSFetchedResultsControllerDelegate
extension DeckViewController : NSFetchedResultsControllerDelegate {
    
}



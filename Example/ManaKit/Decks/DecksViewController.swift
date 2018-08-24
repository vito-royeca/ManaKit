//
//  DecksViewController.swift
//  ManaKit_Example
//
//  Created by Jovito Royeca on 23.08.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import CoreData
import ManaKit

class DecksViewController: UIViewController {

    // MARK: Variables
    var fetchedResultsController: NSFetchedResultsController<CMDeck>?
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(ManaKit.sharedInstance.nibFromBundle("DeckTableViewCell"),
                           forCellReuseIdentifier: DeckTableViewCell.reuseIdentifier)
        fetchedResultsController = getFetchedResultsController(with: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDeck" {
            guard let dest = segue.destination as? DeckViewController,
                let deck = sender as? CMDeck else {
                return
            }
            
            dest.deck = deck
            dest.title = deck.name
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: Custom methods
    func getFetchedResultsController(with fetchRequest: NSFetchRequest<CMDeck>?) -> NSFetchedResultsController<CMDeck> {
        let context = ManaKit.sharedInstance.dataStack!.viewContext
        var request: NSFetchRequest<CMDeck>?
        
        if let fetchRequest = fetchRequest {
            request = fetchRequest
        } else {
            // Create a default fetchRequest
            request = CMDeck.fetchRequest()
            request!.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
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
extension DecksViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let fetchedResultsController = fetchedResultsController,
            let decks = fetchedResultsController.fetchedObjects else {
                return 0
        }
        
        return decks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let fetchedResultsController = fetchedResultsController,
            let cell = tableView.dequeueReusableCell(withIdentifier: DeckTableViewCell.reuseIdentifier,
                                                     for: indexPath) as? DeckTableViewCell else {
            fatalError("Unexpected indexPath: \(indexPath)")
        }
        
        let deck = fetchedResultsController.object(at: indexPath)
        
        // Configure Cell
        cell.deck = deck
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension DecksViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let fetchedResultsController = fetchedResultsController else {
            return
        }
        
        let deck = fetchedResultsController.object(at: indexPath)
        performSegue(withIdentifier: "showDeck", sender: deck)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(88)
    }
}

// MARK: NSFetchedResultsControllerDelegate
extension DecksViewController : NSFetchedResultsControllerDelegate {
    
}

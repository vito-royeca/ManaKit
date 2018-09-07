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
    var mainboardViewModel: DeckMainboardViewModel!
    var sideboardViewModel: DeckSideboardViewModel!
    
    // MARK: Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!

    // MARK: Actions
    @IBAction func segmentedAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mainboardViewModel.performSearch()
            tableView.reloadData()
        case 1:
            sideboardViewModel.performSearch()
            tableView.reloadData()
        default:
            ()
        }
    }
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(ManaKit.sharedInstance.nibFromBundle("CardTableViewCell"), forCellReuseIdentifier: CardTableViewCell.reuseIdentifier)
        
//        title = mainboardViewModel.objectTitle()
        mainboardViewModel.performSearch()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCard" {
            guard let dest = segue.destination as? CardViewController,
                let card = sender as? CMCard else {
                    return
            }
            
            dest.card = card
            dest.title = card.name
        }
    }
}

// MARK: UITableViewDataSource
extension DeckViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            rows = mainboardViewModel.tableViewNumberOfRows(inSection: section)
        case 1:
            rows = sideboardViewModel.tableViewNumberOfRows(inSection: section)
        default:
            ()
        }
        
        return rows
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var sections = 0
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            sections = mainboardViewModel.tableViewNumberOfSections()
        case 1:
            sections = sideboardViewModel.tableViewNumberOfSections()
        default:
            ()
        }
        
        return sections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? CardTableViewCell else {
            fatalError("Unexpected indexPath: \(indexPath)")
        }
        
        var cardInventory: CMCardInventory?
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            cardInventory = mainboardViewModel.object(forRowAt: indexPath)
        case 1:
            cardInventory = sideboardViewModel.object(forRowAt: indexPath)
        default:
            ()
        }
        
        guard let ci = cardInventory else {
            fatalError("Unexpected indexPath: \(indexPath)")
        }
        
        cell.card = ci.card
        cell.add(annotation: Int(ci.quantity))

        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var array: [String]?
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            array = mainboardViewModel.tableViewSectionIndexTitles()
        case 1:
            array = sideboardViewModel.tableViewSectionIndexTitles()
        default:
            ()
        }
        
        return array
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        var section = 0
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            section = mainboardViewModel.tableViewSectionForSectionIndexTitle(title: title, at: index)
        case 1:
            section = sideboardViewModel.tableViewSectionForSectionIndexTitle(title: title, at: index)
        default:
            ()
        }
        
        return section
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var string: String?
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            string = mainboardViewModel.tableViewTitleForHeaderInSection(section: section)
        case 1:
            string = sideboardViewModel.tableViewTitleForHeaderInSection(section: section)
        default:
            ()
        }
        
        return string
    }
}

// MARK: UITableViewDelegate
extension DeckViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var cardInventory: CMCardInventory?
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            cardInventory = mainboardViewModel.object(forRowAt: indexPath)
        case 1:
            cardInventory = sideboardViewModel.object(forRowAt: indexPath)
        default:
            ()
        }
        
        guard let ci = cardInventory else {
            return
        }
        performSegue(withIdentifier: "showCard", sender: ci.card)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kCardTableViewCellHeight
    }
}


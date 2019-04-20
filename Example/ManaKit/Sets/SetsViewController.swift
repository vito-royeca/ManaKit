//
//  SetsViewController.swift
//  ManaKit
//
//  Created by Jovito Royeca on 15/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import ManaKit

class SetsViewController: UIViewController {

    // MARK: Variables
    let searchController = UISearchController(searchResultsController: nil)
    let viewModel = SetsViewModel()

    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Filter"
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        tableView.keyboardDismissMode = .onDrag
        
        tableView.register(ManaKit.sharedInstance.nibFromBundle("SetTableViewCell"),
                           forCellReuseIdentifier: SetTableViewCell.reuseIdentifier)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: MaintainerKeys.MaintainanceDone),
                                                  object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadSets(_:)),
                                               name: NSNotification.Name(rawValue: MaintainerKeys.MaintainanceDone),
                                               object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
        
        if viewModel.isEmpty() {
            viewModel.fetchData()
            tableView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSet" {
            guard let dest = segue.destination as? SetViewController,
                let dict = sender as? [String: Any],
                let set = dict["set"] as? CMSet,
                let languageCode = dict["languageCode"] as? String  else {
                return
            }
            
            let viewModel = SetViewModel(withSet: set,
                                         languageCode: languageCode)
            dest.viewModel = viewModel
        }
    }
    
    // Notification handler
    @objc func reloadSets(_ notification: Notification) {
        tableView.reloadData()
    }
}

// MARK: UITableViewDataSource
extension SetsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(inSection: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SetTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? SetTableViewCell else {
            fatalError("Unexpected indexPath: \(indexPath)")
        }
        
        cell.set = viewModel.object(forRowAt: indexPath)
        cell.delegate = self
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return viewModel.sectionIndexTitles()
    }

    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return viewModel.sectionForSectionIndexTitle(title: title, at: index)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForHeaderInSection(section: section)
    }
}

// MARK: UITableViewDelegate
extension SetsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SetTableViewCell.cellHeight
    }
}

// MARK: UISearchResultsUpdating
extension SetsViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        viewModel.queryString = text
        viewModel.fetchData()
        tableView.reloadData()
    }
}

// MARK: UISearchResultsUpdating
extension SetsViewController : UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel.searchCancelled = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchCancelled = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if viewModel.searchCancelled {
            searchBar.text = viewModel.queryString
        } else {
            viewModel.queryString = searchBar.text ?? ""
        }
    }
}

// MARK: SetsTableViewCellDelegate
extension SetsViewController: SetTableViewCellDelegate {
    func languageAction(cell: UITableViewCell, code: String) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        let set = viewModel.object(forRowAt: indexPath)
        let sender = ["set": set,
                      "languageCode": code] as [String : Any]
        performSegue(withIdentifier: "showSet", sender: sender)
    }
}

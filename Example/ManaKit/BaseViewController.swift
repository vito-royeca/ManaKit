//
//  BaseViewController.swift
//  ManaKit
//
//  Created by Vito Royeca on 11/30/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import CoreData
import ManaKit
import MBProgressHUD
import PromiseKit

class BaseViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Variables
    let searchController = UISearchController(searchResultsController: nil)
    var viewModel: BaseViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchData()
    }

    // MARK: Custom methods
    func fetchData() {
        if viewModel.willFetchCache() {
            MBProgressHUD.showAdded(to: view, animated: true)
            
            firstly {
                viewModel.fetchRemoteData()
            }.compactMap { (data, result) in
                try JSONSerialization.jsonObject(with: data) as? [[String: Any]]
            }.then { data in
                self.viewModel.saveLocalData(data: data)
            }.then {
                self.viewModel.fetchLocalData()
            }.done {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.title = self.viewModel.title
                self.tableView.reloadData()
            }.catch { error in
                self.viewModel.deleteCache()
                MBProgressHUD.hide(for: self.view, animated: true)
                self.tableView.reloadData()
            }
        } else {
            firstly {
                viewModel.fetchLocalData()
            }.done {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.tableView.reloadData()
            }.catch { error in
                self.viewModel.deleteCache()
                MBProgressHUD.hide(for: self.view, animated: true)
                self.title = self.viewModel.title
                self.tableView.reloadData()
            }
        }
    }

}

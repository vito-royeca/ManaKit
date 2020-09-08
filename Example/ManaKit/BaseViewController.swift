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
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    let searchController = UISearchController(searchResultsController: nil)
    var viewModel: BaseViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Custom methods
    func fetchData() {
        let callback = { (error: Error?) in
            if let error = error {
                print(error)
            }
            
            MBProgressHUD.hide(for: self.view,
                               animated: true)
            self.title = self.viewModel.title
            self.tableView.reloadData()
        }
        
        MBProgressHUD.showAdded(to: self.view,
                                animated: true)
        viewModel.fetchData(callback: callback)
    }
}

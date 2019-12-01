//
//  MainViewController.swift
//  ManaKit
//
//  Created by Jovito Royeca on 14.10.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import FontAwesome_swift

class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let items = self.tabBar.items else {
            return
        }
        
        items[0].image = UIImage.fontAwesomeIcon(name: .book,
                                                 style: .solid,
                                                 textColor: UIColor.blue,
                                                 size: CGSize(width: 30, height: 30))
//        items[1].image = UIImage.fontAwesomeIcon(name: .cubes,
//                                                 style: .solid,
//                                                 textColor: UIColor.blue,
//                                                 size: CGSize(width: 30, height: 30))
        for v in viewControllers ?? [UIViewController]() {
            if let navVC = v as? UINavigationController {
                for vv in navVC.viewControllers {
                    if let setsVC = vv as? SetsViewController {
                        setsVC.viewModel = SetsViewModel()
                    }
                }
            }
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

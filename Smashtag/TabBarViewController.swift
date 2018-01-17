//
//  TabBarViewController.swift
//  Smashtag
//
//  Created by Iza Ledzka on 17/01/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let navcon = viewController as? UINavigationController {
            if let selectedView = navcon.visibleViewController as? SearchesTableViewController {
                selectedView.refreshUI()
            }
        } else {
            if let selectedView = viewController as? SearchesTableViewController {
                selectedView.refreshUI()
            }
        }
    }
}

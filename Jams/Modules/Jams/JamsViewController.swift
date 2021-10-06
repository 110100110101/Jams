//
//  JamsViewController.swift
//  Jams
//
//  Created by Jaja Yting on 10/6/21.
//

import UIKit

class JamsViewController: UIViewController {
    
    // MARK: - Fields
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.navigationItem.searchController = self.searchController
    }
}

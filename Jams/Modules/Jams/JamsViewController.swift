//
//  JamsViewController.swift
//  Jams
//
//  Created by Jaja Yting on 10/6/21.
//

import UIKit

class JamsViewController: UIViewController, UISearchBarDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet private var tableViewJams: UITableView!
    
    // MARK: - Fields
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.navigationItem.title = "Jams"
        
        self.navigationItem.searchController = self.searchController
        self.searchController.searchBar.delegate = self
    }
    
    // MARK: - UISearchBarDelegate Methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // TODO: Search
    }
}

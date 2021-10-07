//
//  JamsViewController.swift
//  Jams
//
//  Created by Jaja Yting on 10/6/21.
//

import UIKit

class JamsViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource {
    
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
        self.searchController.searchBar.placeholder = "Find Your Jams!"
        
        self.initializeTableViewJamsProperties()
    }
    
    // MARK: - UISearchBarDelegate Methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // TODO: Search
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0 // TODO: Return proper number of rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell() // TODO: Return preferred instance of cell
    }
    
    // MARK: - Private Methods
    
    private func initializeTableViewJamsProperties() {
        
        let nib = UINib(nibName: "JamTableViewCell", bundle: nil)
        self.tableViewJams.register(nib, forCellReuseIdentifier: "JamTableViewCell")
        
        self.tableViewJams.dataSource = self
        self.tableViewJams.rowHeight = 116.0
    }
}

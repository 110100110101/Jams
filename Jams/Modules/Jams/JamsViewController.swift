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
    
    private let viewModel: JamsViewModel
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Initializer
    
    convenience init() {
        fatalError("Use the designated initializer init(viewModel:)!")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented, so use init(viewModel:)!")
    }
    
    init(viewModel: JamsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
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
        self.viewModel.search(searchText)
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.jams.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: JamTableViewCell.reuseIdentifier, for: indexPath) as! JamTableViewCell
        
        let data = self.viewModel.jams.value[indexPath.row]
        
        dequeuedCell.setTrackName(data.trackName)
        dequeuedCell.setTrackArtwork(url: data.trackArtwork)
        dequeuedCell.setGenre(data.genre)
        dequeuedCell.setShortDescription(data.trackShortDescription)
        dequeuedCell.isFavorite = data.isFavorite
        
        // TODO: Set delegate
        
        return dequeuedCell
    }
    
    // MARK: - Private Methods
    
    private func initializeTableViewJamsProperties() {
        
        let nib = UINib(nibName: JamTableViewCell.reuseIdentifier, bundle: nil)
        self.tableViewJams.register(nib, forCellReuseIdentifier: JamTableViewCell.reuseIdentifier)
        
        self.tableViewJams.dataSource = self
        self.tableViewJams.rowHeight = 116.0
    }
}

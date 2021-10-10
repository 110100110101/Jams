//
//  MyJamsViewController.swift
//  Jams
//
//  Created by Jaja Yting on 10/6/21.
//

import UIKit

class MyJamsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet private var tableViewFavoriteJams: UITableView!
    
    // MARK: - Fields
    
    private let viewModel: MyJamsViewModel
    
    // MARK: - Initializers
    
    convenience init() {
        fatalError("Use the designated initializer init(viewModel:)!")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented, so use init(viewModel:)!")
    }
    
    init(viewModel: MyJamsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "My Jams"
        
        self.initializeTableViewJamsProperties()
    }

    // MARK: - UITableViewDataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.favoriteJams.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: JamTableViewCell.reuseIdentifier, for: indexPath) as! JamTableViewCell
        
        let data = self.viewModel.favoriteJams.value[indexPath.row]
        
        dequeuedCell.setTrackName(data.jamName)
        dequeuedCell.setTrackArtwork(url: data.jamArtwork)
        dequeuedCell.setGenre(data.jamGenre)
        dequeuedCell.isFavorite = true
        
        dequeuedCell.accessoryType = .disclosureIndicator
        
        // TODO: Set delegate
        
        return dequeuedCell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailsViewController = JamDetailsViewController()
        self.navigationController?.pushViewController(detailsViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Private Methods
    
    private func initializeTableViewJamsProperties() {
        
        let nib = UINib(nibName: JamTableViewCell.reuseIdentifier, bundle: nil)
        self.tableViewFavoriteJams.register(nib, forCellReuseIdentifier: JamTableViewCell.reuseIdentifier)
        
        self.tableViewFavoriteJams.dataSource = self
        self.tableViewFavoriteJams.delegate = self
        self.tableViewFavoriteJams.rowHeight = 116.0
    }
}

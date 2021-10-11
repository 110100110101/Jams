//
//  JamsViewController.swift
//  Jams
//
//  Created by Jaja Yting on 10/6/21.
//

import UIKit
import RxSwift

class JamsViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate, JamTableViewCellDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet private var tableViewJams: UITableView!
    
    // MARK: - Fields
    
    private let viewModel: JamsViewModel
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    /**
     Last search term of the user
     
     - Note: Used to fill the searchBar after tapping the cancel button.
     */
    private var lastSearchedTerm: String?
    
    private let disposeBag = DisposeBag()
    
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
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.placeholder = "Find Your Jams!"
        
        self.initializeTableViewJamsProperties()
        
        self.configureBindings()
    }
    
    // MARK: - UISearchControllerDelegate Methods
    
    func didDismissSearchController(_ searchController: UISearchController) {
        searchController.searchBar.text = self.lastSearchedTerm
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        self.lastSearchedTerm = searchController.searchBar.text
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
        dequeuedCell.isFavorite = data.isFavorite
        
        dequeuedCell.accessoryType = .disclosureIndicator
        
        dequeuedCell.delegate = self
        
        return dequeuedCell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        let jam = self.viewModel.jams.value[indexPath.row]
        
        let detailsDataSource = JamDetailsDataSource()
        let detailsViewModel = JamDetailsViewModel(jam: jam, isFavorite: true, dataSource: detailsDataSource)
        let detailsViewController = JamDetailsViewController(viewModel: detailsViewModel)
        self.navigationController?.pushViewController(detailsViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - JamTableViewCellDelegate Methods
    
    func jamTableViewCellButtonFavoriteDidTap(_ cell: JamTableViewCell) {
        
        guard let cellIndexPath = self.tableViewJams.indexPath(for: cell) else {
            return
        }
        
        let fetchedJam = self.viewModel.jams.value[cellIndexPath.row]
        if fetchedJam.isFavorite {
            self.viewModel.removeJamOnFavorites(fetchedJam, completion: { [weak self] in
                self?.tableViewJams.reloadRows(at: [cellIndexPath], with: .automatic)
            })
        }
        else {
            self.viewModel.addJamToFavorites(fetchedJam, completion: { [weak self] in
                self?.tableViewJams.reloadRows(at: [cellIndexPath], with: .automatic)
            })
        }
    }
    
    // MARK: - Private Methods
    
    private func initializeTableViewJamsProperties() {
        
        let nib = UINib(nibName: JamTableViewCell.reuseIdentifier, bundle: nil)
        self.tableViewJams.register(nib, forCellReuseIdentifier: JamTableViewCell.reuseIdentifier)
        
        self.tableViewJams.dataSource = self
        self.tableViewJams.delegate = self
        self.tableViewJams.rowHeight = 116.0
    }
    
    private func configureBindings() {
        
        // MARK: jams
        
        self.viewModel.jams
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.tableViewJams.reloadData()
            })
            .disposed(by: self.disposeBag)
    }
}

//
//  JamsViewController.swift
//  Jams
//
//  Created by Jaja Yting on 10/6/21.
//

import UIKit
import RxSwift
import DZNEmptyDataSet

/**
 JamsViewController Restoration Keys! 
 */
fileprivate enum JamsViewControllerRestorationKeys {
    static let searchBarValue = "searchBarValue"
}

class JamsViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate, JamTableViewCellDelegate, DZNEmptyDataSetSource {
    
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
        
        self.restorationIdentifier = "JamsViewController"
        self.restorationClass = JamsViewController.self
     
        self.navigationItem.title = "Jams"
        
        self.navigationItem.searchController = self.searchController
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.placeholder = "Find Your Jams!"
        
        self.initializeTableViewJamsProperties()
        
        self.configureBindings()
    }
    
    // MARK: - UIStateRestoring Methods
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        
        coder.encode(self.searchController.searchBar.text, forKey: JamsViewControllerRestorationKeys.searchBarValue)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        
        let lastSearchedTerm = coder.decodeObject(forKey: JamsViewControllerRestorationKeys.searchBarValue) as? String
        self.searchController.searchBar.text = lastSearchedTerm
        
        if let lastSearchedTerm = lastSearchedTerm {
            self.viewModel.search(lastSearchedTerm)
        }
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
        let detailsViewModel = JamDetailsViewModel(jam: jam, isFavorite: jam.isFavorite, dataSource: detailsDataSource)
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
    
    // MARK: - DZNEmptyDataSetSource Methods
    
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        
        let currentSearchPhrase = self.searchController.searchBar.text ?? ""
        let hasEncounteredAnErrorWhileSearching = self.viewModel.hasEncounteredAnErrorWhileSearching.value
        
        if currentSearchPhrase.isEmpty && !hasEncounteredAnErrorWhileSearching {
            
            let emptyStateView = UINib(nibName: "JamsCleanRunStateView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? UIView
            return emptyStateView
        }
        else if !currentSearchPhrase.isEmpty && !hasEncounteredAnErrorWhileSearching {
            let emptyStateView = UINib(nibName: "JamsNoResultsView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? UIView
            return emptyStateView
        }
        else {
            // TODO: Return error state
            return nil
        }
    }
    
    // MARK: - Private Methods
    
    private func initializeTableViewJamsProperties() {
        
        let nib = UINib(nibName: JamTableViewCell.reuseIdentifier, bundle: nil)
        self.tableViewJams.register(nib, forCellReuseIdentifier: JamTableViewCell.reuseIdentifier)
        
        self.tableViewJams.dataSource = self
        self.tableViewJams.delegate = self
        self.tableViewJams.emptyDataSetSource = self
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

extension JamsViewController: UIViewControllerRestoration {
    
    static func viewController(withRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
        
        let jamsDataSource = JamsDataSource()
        let jamsViewModel = JamsViewModel(dataSource: jamsDataSource)
        let jamsViewController = JamsViewController(viewModel: jamsViewModel) // Restoration ID was set at nib
        
        return jamsViewController
    }
}

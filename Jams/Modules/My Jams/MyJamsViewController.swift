//
//  MyJamsViewController.swift
//  Jams
//
//  Created by Jaja Yting on 10/6/21.
//

import UIKit
import RxSwift

class MyJamsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, JamTableViewCellDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet private var tableViewFavoriteJams: UITableView!
    
    // MARK: - Fields
    
    private let viewModel: MyJamsViewModel
    
    private let disposeBag = DisposeBag()
    
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
        
        self.configureBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.getAllFavoriteJams()
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
        
        dequeuedCell.delegate = self
        
        return dequeuedCell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailsViewController = JamDetailsViewController()
        self.navigationController?.pushViewController(detailsViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - JamTableViewCellDelegate Methods
    
    func jamTableViewCellButtonFavoriteDidTap(_ cell: JamTableViewCell) {
        
        guard let cellIndexPath = self.tableViewFavoriteJams.indexPath(for: cell) else {
            return
        }
        
        let favoriteJam = self.viewModel.favoriteJams.value[cellIndexPath.row]
        self.viewModel.removeFavoriteJam(favoriteJam, completion: nil)
    }
    
    // MARK: - Private Methods
    
    private func initializeTableViewJamsProperties() {
        
        let nib = UINib(nibName: JamTableViewCell.reuseIdentifier, bundle: nil)
        self.tableViewFavoriteJams.register(nib, forCellReuseIdentifier: JamTableViewCell.reuseIdentifier)
        
        self.tableViewFavoriteJams.dataSource = self
        self.tableViewFavoriteJams.delegate = self
        self.tableViewFavoriteJams.rowHeight = 116.0
    }
    
    private func configureBindings() {
        
        self.viewModel.favoriteJams
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.tableViewFavoriteJams.reloadData()
            })
            .disposed(by: self.disposeBag)
    }
}

//
//  JamDetailsViewController.swift
//  Jams
//
//  Created by Jaja Yting on 10/7/21.
//

import UIKit
import RxSwift
import Kingfisher
import Avatar

fileprivate enum JamDetailsViewControllerRestorationKeys {
    
    static let selectedJamID = "selectedJamID"
    static let selectedJamName = "selectedJamName"
    static let selectedJamArtwork = "selectedJamArtwork"
    static let selectedjamDescription = "selectedjamDescription"
    static let selectedJamGenre = "selectedJamGenre"
    static let selectedJamCurrency = "selectedJamCurrency"
    static let selectedJamTrackPrice = "selectedJamTrackPrice"
    static let selectedJamIsFavorite = "selectedJamIsFavorite"
}

class JamDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private var imageViewTrackArtwork: UIImageView!
    @IBOutlet private var labelTrackName: UILabel!
    @IBOutlet private var labelGenre: UILabel!
    @IBOutlet private var labelLongDescription: UILabel!
    @IBOutlet private var buttonFavorite: UIButton!
    
    // MARK: - Fields
    
    private let viewModel: JamDetailsViewModel
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    
    convenience init() {
        fatalError("Use the designated initializer init(viewModel:)!")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented, so use init(viewModel:)!")
    }
    
    init(viewModel: JamDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.restorationIdentifier = "JamDetailsViewController"
        self.restorationClass = JamDetailsViewController.self

        self.configureBindings()
    }
    
    // MARK: - UIStateRestoring Methods
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        
        let selectedJam = self.viewModel.jam.value
        coder.encode(selectedJam.jamID, forKey: JamDetailsViewControllerRestorationKeys.selectedJamID)
        coder.encode(selectedJam.jamName, forKey: JamDetailsViewControllerRestorationKeys.selectedJamName)
        coder.encode(selectedJam.jamArtwork.absoluteString, forKey: JamDetailsViewControllerRestorationKeys.selectedJamArtwork)
        coder.encode(selectedJam.jamDescription, forKey: JamDetailsViewControllerRestorationKeys.selectedjamDescription)
        
        coder.encode(selectedJam.jamCurrency, forKey: JamDetailsViewControllerRestorationKeys.selectedJamCurrency)
        
        if let trackPrice = selectedJam.jamTrackPrice {
            coder.encode("\(trackPrice)", forKey: JamDetailsViewControllerRestorationKeys.selectedJamTrackPrice)
        }
        
        coder.encode(selectedJam.jamGenre, forKey: JamDetailsViewControllerRestorationKeys.selectedJamGenre)
        
        let isFavorite = self.viewModel.isFavorite.value
        coder.encode(isFavorite, forKey: JamDetailsViewControllerRestorationKeys.selectedJamIsFavorite)
    }
    
    // MARK: - Action Methods
    
    @IBAction private func buttonFavoriteDidTap() {
        self.viewModel.toggleFavorites()
    }

    // MARK: - Private Methods
    
    private func configureBindings() {
        
        // MARK: jam
        
        self.viewModel.jam
            .asDriver()
            .drive(onNext: { [unowned self] (jam) in
                
                self.labelTrackName.text = jam.jamName
                self.labelGenre.text = jam.jamGenre
                self.labelLongDescription.text = jam.jamDescription
                                
                let frameSize = self.imageViewTrackArtwork.frame.size
                self.imageViewTrackArtwork.kf.indicatorType = .activity
                self.imageViewTrackArtwork.kf.setImage(with: jam.jamArtwork,
                                                       placeholder: nil,
                                                       options: [
                                                        .scaleFactor(UIScreen.main.scale),
                                                        .transition(.fade(0.3))
                                                       ],
                                                       completionHandler: { (result) in
                                                        switch result {
                                                        case .failure:
                                                            Avatar.generate(for: frameSize,
                                                                            scale: 12,
                                                                            complete: { [weak self] (_, image) in
                                                                                self?.imageViewTrackArtwork.image = image
                                                                            })
                                                        default:
                                                            break
                                                        }
                                                       })
                
                if let formattedTrackPrice = jam.formattedTrackPrice {
                    let rightBarButtonItem = UIBarButtonItem(title: formattedTrackPrice, style: .plain, target: nil, action: nil)
                    self.navigationItem.setRightBarButton(rightBarButtonItem, animated: true)
                }
            })
            .disposed(by: self.disposeBag)
        
        // MARK: isFavorite
        
        self.viewModel.isFavorite
            .asDriver()
            .drive(onNext: { [weak self] (isFavorite) in
                
                guard let self = self else {
                    return
                }
                
                let systemImageName: String
                if isFavorite {
                    systemImageName = "heart.fill"
                }
                else {
                    systemImageName = "heart"
                }
                
                let image = UIImage(systemName: systemImageName)
                
                UIView.transition(with: self.buttonFavorite,
                                  duration: 0.25,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    self.buttonFavorite.setImage(image, for: .normal)
                                  },
                                  completion: nil)
            })
            .disposed(by: self.disposeBag)
    }
}

extension JamDetailsViewController: UIViewControllerRestoration {
    
    static func viewController(withRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
        
        let jamID = coder.decodeInt64(forKey: JamDetailsViewControllerRestorationKeys.selectedJamID)
        let jamName = coder.decodeObject(forKey: JamDetailsViewControllerRestorationKeys.selectedJamName) as! String
        
        let parsedJamArtwork = coder.decodeObject(forKey: JamDetailsViewControllerRestorationKeys.selectedJamArtwork) as! String
        let jamArtwork = URL(string: parsedJamArtwork)!
        
        let jamDescription = coder.decodeObject(forKey: JamDetailsViewControllerRestorationKeys.selectedjamDescription) as! String
        let jamGenre = coder.decodeObject(forKey: JamDetailsViewControllerRestorationKeys.selectedJamGenre) as! String
        let jamCurrency = coder.decodeObject(forKey: JamDetailsViewControllerRestorationKeys.selectedJamCurrency) as! String
        
        let parsedJamTrackPrice = coder.decodeObject(forKey: JamDetailsViewControllerRestorationKeys.selectedJamTrackPrice) as! String
        let jamTrackPrice = Decimal(string: parsedJamTrackPrice)
    
        let isFavorite = coder.decodeBool(forKey: JamDetailsViewControllerRestorationKeys.selectedJamIsFavorite)
        
        let jam = FetchedJam(trackId: jamID,
                             trackName: jamName,
                             trackArtwork: jamArtwork,
                             trackLongDescription: jamDescription,
                             genre: jamGenre,
                             currency: jamCurrency,
                             trackPrice: jamTrackPrice,
                             isFavorite: isFavorite)
        
        let detailsDataSource = JamDetailsDataSource()
        let detailsViewModel = JamDetailsViewModel(jam: jam, isFavorite: jam.isFavorite, dataSource: detailsDataSource)
        let detailsViewController = JamDetailsViewController(viewModel: detailsViewModel)
        
        return detailsViewController
    }
}

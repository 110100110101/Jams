//
//  JamDetailsViewController.swift
//  Jams
//
//  Created by Jaja Yting on 10/7/21.
//

import UIKit
import RxSwift
import Kingfisher

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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureBindings()
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
                                
                self.imageViewTrackArtwork.kf.indicatorType = .activity
                self.imageViewTrackArtwork.kf.setImage(with: jam.jamArtwork,
                                                       placeholder: nil, // TODO: Provide a placeholder
                                                       options: [
                                                        .scaleFactor(UIScreen.main.scale),
                                                        .transition(.fade(0.3))
                                                       ])
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

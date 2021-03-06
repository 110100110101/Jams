//
//  JamTableViewCell.swift
//  Jams
//
//  Created by Jaja Yting on 10/6/21.
//

import UIKit
import Kingfisher
import Avatar

protocol JamTableViewCellDelegate: AnyObject {
    
    /**
     Informs the delegate that the given instance's favorite button has been tapped
     
     - parameter cell: Instance where the event did just happened
     */
    func jamTableViewCellButtonFavoriteDidTap(_ cell: JamTableViewCell)
}

class JamTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private var imageViewTrackArtwork: UIImageView!
    @IBOutlet private var labelTrackName: UILabel!
    @IBOutlet private var buttonFavorite: UIButton!
    @IBOutlet private var labelGenre: UILabel!
    @IBOutlet private var buttonPurchase: UIButton!
    
    // MARK: - Fields
    
    /**
     Identifier assigned to instances of this cell
     
     - Note: This also serves as the name of nib of this cell.
     */
    public static let reuseIdentifier = "JamTableViewCell"
    
    /**
     Delegate where all the "important" events would be routed/handled
     */
    public weak var delegate: JamTableViewCellDelegate?
    
    /**
     A boolean value that determines whether this jam is one of his/her favorites
     */
    public var isFavorite: Bool = false {
        didSet {
            self.toggleFavoriteButton(isFavorite: self.isFavorite)
        }
    }
    
    private var _isFavorite: Bool = false
    
    // MARK: - View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /*
         Clear the data to prevent the data assigned in nib to be rendered,
         if the consumer forgots to set data to it
         */
        self.clearData()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Clear the data assigned to prevent data from other jams to leak on other instances
        self.clearData()
    }
    
    // MARK: - Public Methods
    
    /**
     Sets the artwork
     
     - parameter url: URL where the artwork resides.
     
     - Note: If an error has occurred, it would use the internal placeholder instead
     */
    public func setTrackArtwork(url: URL) {
        
        let frameSize = self.imageViewTrackArtwork.frame.size
        self.imageViewTrackArtwork.kf.indicatorType = .activity
        self.imageViewTrackArtwork.kf.setImage(with: url,
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
    }
    
    public func setTrackName(_ name: String) {
        self.labelTrackName.text = name
    }
    
    public func setGenre(_ genre: String) {
        self.labelGenre.text = genre
    }
    
    /**
     Assigns price to the Jam
     
     - Note: Formatting and currency isn't handled on this method, so format it prior to rendering
     */
    public func setPrice(_ price: String?) {
        
        if let price = price {
            self.buttonPurchase.setTitle(price, for: .normal)
        }
        else {
            self.buttonPurchase.isHidden = true
        }
    }
    
    // MARK: - Action Methods
    
    @IBAction private func buttonFavoriteDidTap() {
        self.delegate?.jamTableViewCellButtonFavoriteDidTap(self)
    }
    
    // MARK: - Private Methods
    
    private func toggleFavoriteButton(isFavorite: Bool) {
        
        let systemImageName: String
        if isFavorite {
            systemImageName = "heart.fill"
        }
        else {
            systemImageName = "heart"
        }
        
        let image = UIImage(systemName: systemImageName)
        self.buttonFavorite.setImage(image, for: .normal)
    }
    
    /**
     Clears the data assigned to the views in this instance
     */
    private func clearData() {
        
        self.imageViewTrackArtwork.image = nil
        self.labelTrackName.text = nil
        self.labelGenre.text = nil
        self.buttonFavorite.setImage(nil, for: .normal)
        self.buttonPurchase.isHidden = false
        self.buttonPurchase.setTitle(nil, for: .normal)
    }
}

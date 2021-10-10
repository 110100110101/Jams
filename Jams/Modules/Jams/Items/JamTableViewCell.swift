//
//  JamTableViewCell.swift
//  Jams
//
//  Created by Jaja Yting on 10/6/21.
//

import UIKit

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
    public var isFavorite: Bool {
        
        get {
            return self._isFavorite
        }
        
        set (isFavorite) {
            
            if isFavorite != self._isFavorite {
                self._isFavorite = isFavorite
                self.toggleFavoriteButton(isFavorite: isFavorite)
            }
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
     
     - parameter url: URL where the artwork resides. Specify `nil` if you want the view to use placeholder
     
     - Note: Placeholder would be also served while the view loads the artwork from the `url`. If an error has occurred, it would also use the placeholder.
     */
    public func setTrackArtwork(url: URL?) {
        // TODO: Set the track's artwork using the provided URL, if possible
    }
    
    public func setTrackName(_ name: String) {
        self.labelTrackName.text = name
    }
    
    public func setGenre(_ genre: String) {
        self.labelGenre.text = genre
    }
    
    // MARK: - Private Methods
    
    private func toggleFavoriteButton(isFavorite: Bool) {
        
        let systemImageName: String
        if isFavorite {
            systemImageName = "heart"
        }
        else {
            systemImageName = "heart.fill"
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
    }
}

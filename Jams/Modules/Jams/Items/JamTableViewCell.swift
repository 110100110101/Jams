//
//  JamTableViewCell.swift
//  Jams
//
//  Created by Jaja Yting on 10/6/21.
//

import UIKit

protocol JamTableViewCellDelegate: AnyObject {
    
    /**
     Informs the delegate that the given instance's purchase button has been tapped
     
     - parameter cell: Instance where the event did just happened
     */
    func jamTableViewCellButtonPurchaseDidTap(_ cell: JamTableViewCell)
}

class JamTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private var imageViewTrackArtwork: UIImageView!
    @IBOutlet private var labelTrackName: UILabel!
    @IBOutlet private var buttonFavorite: UIButton!
    @IBOutlet private var labelGenre: UILabel!
    @IBOutlet private var buttonPurchase: UIButton! // This button also doubles as the price tag
    
    // MARK: - Fields
    
    /**
     Delegate where all the "important" events would be routed/handled
     */
    public weak var delegate: JamTableViewCellDelegate?
    
    // MARK: - View Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Reset the data assigned to prevent data from other jams to leak on other instances
        
        self.imageViewTrackArtwork.image = nil
        self.labelTrackName.text = nil
        self.labelGenre.text = nil
        self.buttonPurchase.setTitle(nil, for: .normal)
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
    
    /**
     Assigns price to the track
     
     - Note: Argument passed is rendered as-is, so format it before assigning it here.
     */
    public func setPrice(_ price: String) {
        self.buttonPurchase.setTitle(price, for: .normal)
    }
}

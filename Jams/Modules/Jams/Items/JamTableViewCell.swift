//
//  JamTableViewCell.swift
//  Jams
//
//  Created by Jaja Yting on 10/6/21.
//

import UIKit

class JamTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private var imageViewTrackArtwork: UIImageView!
    @IBOutlet private var labelTrackName: UILabel!
    @IBOutlet private var labelGenre: UILabel!
    @IBOutlet private var buttonPurchase: UIButton! // This button also serves the price tag for the track
    
    // MARK: - View Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Reset the data assigned to prevent data from other jams to leak on other instances
        
        self.imageViewTrackArtwork.image = nil
        self.labelTrackName.text = nil
        self.labelGenre.text = nil
        self.buttonPurchase.setTitle(nil, for: .normal)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

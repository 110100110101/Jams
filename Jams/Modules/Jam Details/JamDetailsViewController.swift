//
//  JamDetailsViewController.swift
//  Jams
//
//  Created by Jaja Yting on 10/7/21.
//

import UIKit

class JamDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private var imageViewTrackArtwork: UIImageView!
    @IBOutlet private var labelTrackName: UILabel!
    @IBOutlet private var labelGenre: UILabel!
    @IBOutlet private var labelLongDescription: UILabel!
    @IBOutlet private var buttonFavorite: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

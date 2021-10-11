//
//  JamTabBarController.swift
//  Jams
//
//  Created by Jaja Yting on 10/11/21.
//

import UIKit

fileprivate enum JamTabBarControllerRestorationKeys {
    static let selectedIndex = "selectedIndex"
}

class JamTabBarController: UITabBarController {
    
    // MARK: - UIStateRestoring Methods
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        
        coder.encode(self.selectedIndex, forKey: JamTabBarControllerRestorationKeys.selectedIndex)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        
        let selectedIndex = coder.decodeInteger(forKey: JamTabBarControllerRestorationKeys.selectedIndex)
        self.selectedIndex = selectedIndex
    }
}

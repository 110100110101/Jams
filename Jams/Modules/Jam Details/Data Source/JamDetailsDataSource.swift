//
//  JamDetailsDataSource.swift
//  Jams
//
//  Created by Jaja Yting on 10/11/21.
//

import Foundation

/**
 Designated data source for Jam Details View
 */
class JamDetailsDataSource: JamDetailsViewModelDataSource {
    
    // MARK: - JamDetailsViewModelDataSource Methods
    
    func addJamToFavorites(_ jam: Jammable, completion: @escaping (Bool) -> ()) {
        CoreDataManager.sharedInstance.addFavoriteJam(jam: jam, completion: { (_, error) in
            completion(error == nil)
        })
    }
    
    func removeJamOnFavorites(_ jam: Jammable, completion: @escaping (Bool) -> ()) {
        CoreDataManager.sharedInstance.deleteFavoriteJam(jam, completion: { (error) in
            completion(error == nil)
        })
    }
}

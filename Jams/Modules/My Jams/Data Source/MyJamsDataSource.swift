//
//  MyJamsDataSource.swift
//  Jams
//
//  Created by Jaja Yting on 10/10/21.
//

import Foundation

/**
 Designated data source for the My Jams View
 */
final class MyJamsDataSource: MyJamsViewModelDataSource {
    
    // MARK: - MyJamsViewModelDataSource Methods
    
    func getAllFavoriteJams(completion: @escaping ([FavoriteJam]?, Error?) -> ()) {
        CoreDataManager.sharedInstance.fetchAllFavoriteJams(completion: completion)
    }
    
    func removeFavoriteJam(_ jam: FavoriteJam, completion: @escaping (Error?) -> ()) {
        CoreDataManager.sharedInstance.deleteFavoriteJam(jam, completion: completion)
    }
}

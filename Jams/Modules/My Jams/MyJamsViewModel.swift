//
//  MyJamsViewModel.swift
//  Jams
//
//  Created by Jaja Yting on 10/10/21.
//

import Foundation

/**
 A data source object which manages the data of the My Jams View
 */
protocol MyJamsViewModelDataSource {
    
    /**
     Asks the data source for all the Favorite Jams of the user
     */
    func getAllFavoriteJams(completion: @escaping ([FavoriteJam]?, Error) -> ())
    
    /**
     Asks the data source to remove the jam on the list
     */
    func remove(jam: FavoriteJam)
}

class MyJamsViewModel {
    
    // MARK: - Fields
    
    private let dataSource: MyJamsViewModelDataSource
    
    // MARK: - Initializer
    
    init(dataSource: MyJamsViewModelDataSource) {
        self.dataSource = dataSource
    }
}

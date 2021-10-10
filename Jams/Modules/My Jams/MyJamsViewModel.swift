//
//  MyJamsViewModel.swift
//  Jams
//
//  Created by Jaja Yting on 10/10/21.
//

import Foundation
import RxCocoa

/**
 A data source object which manages the data of the My Jams View
 */
protocol MyJamsViewModelDataSource {
    
    /**
     Asks the data source for all the Favorite Jams of the user
     */
    func getAllFavoriteJams(completion: @escaping ([FavoriteJam]?, Error?) -> ())
    
    /**
     Asks the data source to remove the jam on the list
     */
    func remove(jam: FavoriteJam)
}

class MyJamsViewModel {
    
    // MARK: - Observable Fields
    
    /**
     Observable field which contains all the favorite jams of the user
     
     - Note: This is updated whenever the `getAllFavoriteJams(completion:)` has been invoked
     */
    public let favoriteJams = BehaviorRelay<[FavoriteJam]>(value: [])
    
    /**
     Determines whether there's an error occurred while fetching for the favorite jams
     */
    public let hasEncounteredAnErrorWhileFetching = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Fields
    
    private let dataSource: MyJamsViewModelDataSource
    
    // MARK: - Initializer
    
    init(dataSource: MyJamsViewModelDataSource) {
        self.dataSource = dataSource
    }
}

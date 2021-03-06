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
     Asks the data source to remove the jam from the favorite list
     */
    func removeFavoriteJam(_ jam: FavoriteJam, completion: @escaping (Error?) -> ())
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
    
    // MARK: - Public Methods
    
    /**
     Fetch all the favorite jams
     
     - Note: Invoking this method updates the value of `favoriteJams` field
     */
    public func getAllFavoriteJams() {
        
        self.dataSource.getAllFavoriteJams(completion: { [weak self] (favoriteJams, error) in
            
            if error != nil {
                self?.hasEncounteredAnErrorWhileFetching.accept(true)
            }
            else if let favoriteJams = favoriteJams {
                self?.favoriteJams.accept(favoriteJams)
                self?.hasEncounteredAnErrorWhileFetching.accept(false)
            }
        })
    }
    
    /**
     Removes the favorite jam from the list
     
     - parameter jam: Jam that gonna be removed from the list
     - parameter completion: Invoked once the operation finishes. It also passes a boolean to indicate if the removal was successful or not.
     
     - Note: This method internally invokes the `getAllFavorites` method to update the list of items
     */
    public func removeFavoriteJam(_ jam: FavoriteJam, completion: ((Bool) -> ())?) {
                
        self.dataSource.removeFavoriteJam(jam, completion: { [weak self] (error) in
            if error == nil {
                self?.getAllFavoriteJams()
                completion?(true)
            }
            else {
                completion?(false)
            }
        })
    }
}

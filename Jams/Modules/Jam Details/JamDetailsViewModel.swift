//
//  JamDetailsViewModel.swift
//  Jams
//
//  Created by Jaja Yting on 10/11/21.
//

import Foundation
import RxCocoa

/**
 An object that manages the list of favorites that may be updated on details view
 */
protocol JamDetailsViewModelDataSource {
    
    /**
     Adds jam to favorites
     
     - parameter jam: Jam to be added on the favorite list
     - parameter completion: Notifies the consumer, if the procedure has been done successfully or not;
     indicated by the boolean value
     */
    func addJamToFavorites(_ jam: Jammable, completion: @escaping (Bool) -> ())
    
    /**
     Removes jam on favorites
     
     - parameter jam: Jam to be remove on the favorite list
     - parameter completion: Notifies the consumer, if the procedure has been done successfully or not;
     indicated by the boolean value
     */
    func removeJamOnFavorites(_ jam: Jammable, completion: @escaping (Bool) -> ())
}

/**
 Designated view model for the Jam Details view
 */
class JamDetailsViewModel {
    
    // MARK: - Observable Fields
    
    public let jam: BehaviorRelay<Jammable>
    
    /**
     Reference to the current state of the jam, if it's already been added to the list or not.
     This can be observed to update the UI of the consumer
     
     - Note: This is updated whenever the `toggleFavorites()` has been invoked and successfully executed
     */
    public let isFavorite: BehaviorRelay<Bool>
    
    // MARK: - Fields
    
    private let dataSource: JamDetailsViewModelDataSource
    
    // MARK: - Initializer
    
    init(jam: Jammable, isFavorite: Bool, dataSource: JamDetailsViewModelDataSource) {
        
        self.jam = BehaviorRelay(value: jam)
        self.isFavorite = BehaviorRelay(value: isFavorite)
        self.dataSource = dataSource
    }
    
    // MARK: - Public Methods
    
    /**
     Asynchronously toggles the favorites state of the jam
     
     - Note: This will update the value of `isFavorites` once the operation has been executed
     */
    public func toggleFavorites() {
        
    }
}

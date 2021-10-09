//
//  JamsViewModel.swift
//  Jams
//
//  Created by Jaja Yting on 10/9/21.
//

import Foundation
import RxCocoa

/**
 The methods that an object adopts to manage and provide jams for Jams' ViewModel
 */
protocol JamsViewModelDataSource {
    
    /**
     Asks the data source to search for Jams
     
     - parameter jam: Name of the Jam
     - parameter completion: Invoked whenever the data source has finished searching for it. Only one of the argument should contain a value.
     */
    func search(jam: String, completion: @escaping ([Any]?, Error?) -> ()) // TODO: Provide proper type for `Any`
    
    /**
     Asks the data source to add/remove the Jam on favorites
     */
    func toggleFavorite(_ isFavorite: Bool, onJam jam: Any) // TODO: Provider type for `Any`
}

class JamsViewModel {
    
    // MARK: - Observable Fields
    
    /**
     Field which the consumer may observe to get the jams. Search results would be also routed here.
     */
    public let jams = BehaviorRelay<[Any]>(value: []) // TODO: Declare proper type
    
    /**
     Determines whether there's an error occurred while searching for jams
     */
    public let hasEncounteredAnErrorWhileSearching = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Fields
    
    private let dataSource: JamsViewModelDataSource
    
    // MARK: - Initializer
    
    init(dataSource: JamsViewModelDataSource) {
        self.dataSource = dataSource
    }
}

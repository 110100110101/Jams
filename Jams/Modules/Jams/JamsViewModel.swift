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
    func search(jam: String, completion: @escaping ([FetchedJam]?, Error?) -> ())
    
    /**
     Asks the data source to mark this jam as favorite
     
     - parameter jam: Jam to be added on the favorite list
     - parameter completion: Invoked whenever the addition of jam was successful or not
     */
    func addJamToFavorites(_ jam: FetchedJam, completion: @escaping (Error?) -> ())
    
    /**
     Asks the data source to remote the jam on favorites list
     
     - parameter jam: Jam to be removed on the list
     - parameter completion: Invoked whenever the removal of jam was successful or not
     */
    func removeJamToFavorites(_ jam: FetchedJam, completion: @escaping (Error?) -> ())
}

class JamsViewModel {
    
    // MARK: - Observable Fields
    
    /**
     Field which the consumer may observe to get the jams. Search results would be also routed here.
     */
    public let jams = BehaviorRelay<[FetchedJam]>(value: [])
    
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
    
    // MARK: - Public Methods
    
    /**
     Search for jams!
     */
    public func search(_ jam: String) {
        
        // Throttling can be implemented on this level to minimize API usage
        
        self.dataSource.search(jam: jam) { [weak self] results, error in
            
            guard let results = results else {
                // The consumer doesn't react on different kinds of error, so just inform it that an error just had occurred
                self?.hasEncounteredAnErrorWhileSearching.accept(true)
                return
            }
            
            self?.jams.accept(results)
        }
    }
    
    /**
     Adds the jam to favorites
     */
    public func addJamToFavorites(_ jam: FetchedJam) {
        
        self.dataSource.addJamToFavorites(jam, completion: { (error) in
            jam.isFavorite = (error == nil)
        })
    }
}

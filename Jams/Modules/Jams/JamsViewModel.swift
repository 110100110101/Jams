//
//  JamsViewModel.swift
//  Jams
//
//  Created by Jaja Yting on 10/9/21.
//

import Foundation
import RxCocoa

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
}

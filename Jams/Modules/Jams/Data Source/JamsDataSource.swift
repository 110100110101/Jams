//
//  JamsDataSource.swift
//  Jams
//
//  Created by Jaja Yting on 10/9/21.
//

import Foundation

final class JamsDataSource: JamsViewModelDataSource {
    
    // MARK: - JamsViewModelDataSource Methods
    
    func search(jam: String, completion: @escaping ([Any]?, Error?) -> ()) {
        // TODO: Search it properly!
        completion([], nil)
    }
    
    func toggleFavorite(_ isFavorite: Bool, onJam jam: Any) {
        // TODO: Toggle it
    }
}

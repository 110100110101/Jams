//
//  Jam.swift
//  Jams
//
//  Created by Jaja Yting on 10/10/21.
//

import Foundation
import CoreData

@objc(FavoriteJam)
class FavoriteJam: NSManagedObject {
    
}

extension FavoriteJam: Jammable {

    var jamID: Int64 {
        return self.trackId!.int64Value
    }
    
    var jamName: String {
        return self.trackName!
    }
    
    var jamArtwork: URL {
        return self.trackArtwork!
    }
    
    var jamDescription: String {
        return self.trackLongDescription!
    }
    
    var jamGenre: String {
        return self.genre!
    }
}

//
//  Jam.swift
//  Jams
//
//  Created by Jaja Yting on 10/10/21.
//

import Foundation
import CoreData

@objc(Jam)
class Jam: NSManagedObject {
    
}

extension Jam: Jammable {

    var jamID: Decimal {
        return self.trackId!.decimalValue
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
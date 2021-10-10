//
//  Jam.swift
//  Jams
//
//  Created by Jaja Yting on 10/10/21.
//

import Foundation
import CoreData

/**
 Class that represents the objects from iTunes Search API & Core Data
 */
class Jam: NSManagedObject, Decodable {
    
    /**
     Initialize object using decoder
     
     - Note: Instances of this object initialized using this initializer must insert this object into a valid MOC to able to save it
     */
    required convenience init(from decoder: Decoder) throws {
        
        // Dummy Context
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.trackName = try container.decode(String.self, forKey: .trackName)
        self.trackArtwork = try container.decode(URL.self, forKey: .trackArtwork)
        self.trackDescription = try container.decode(String.self, forKey: .trackDescription)
        self.genre = try container.decode(String.self, forKey: .genre)
        
        let parsedPrice = try container.decode(Decimal.self, forKey: .price)
        self.price = NSDecimalNumber(decimal: parsedPrice)
        
        self.isFavorite = false
    }
}

private enum CodingKeys: String, CodingKey {
    case trackName
    case trackArtwork = "artworkUrl100"
    case trackDescription = "longDescription"
    case genre = "primaryGenreName"
    case price = "trackPrice"
}

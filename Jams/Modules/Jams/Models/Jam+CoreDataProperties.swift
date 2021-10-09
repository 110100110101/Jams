//
//  Jam+CoreDataProperties.swift
//  
//
//  Created by Jaja Yting on 10/9/21.
//
//

import Foundation
import CoreData


extension Jam {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Jam> {
        return NSFetchRequest<Jam>(entityName: "Jam")
    }

    @NSManaged public var genre: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var price: NSDecimalNumber?
    @NSManaged public var trackArtwork: URL?
    @NSManaged public var trackName: String?

}

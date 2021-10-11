//
//  Jammable.swift
//  Jams
//
//  Created by Jaja Yting on 10/10/21.
//

import Foundation

/**
 Suite of fields that defines what jams are
 */
protocol Jammable {
    
    var jamID: Int64 { get }
    var jamName: String { get }
    var jamArtwork: URL { get }
    var jamDescription: String { get }
    var jamGenre: String { get }
    var jamCurrency: String { get }
    var jamTrackPrice: Decimal? { get }
}

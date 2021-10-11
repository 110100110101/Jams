//
//  FetchedJam.swift
//  Jams
//
//  Created by Jaja Yting on 10/10/21.
//

import Foundation

/**
 Object that represents the Jam fetched from the iTunes Search API
 */
class FetchedJam: Decodable {
    
    public var trackId: Int64
    public var trackName: String
    public var trackArtwork: URL
    public var trackLongDescription: String
    public var genre: String
    public var isFavorite: Bool
    public var currency: String
    public var trackPrice: Decimal?
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.trackId = try container.decode(Int64.self, forKey: .trackId)
        self.trackName = try container.decode(String.self, forKey: .trackName)
        self.trackArtwork = try container.decode(URL.self, forKey: .trackArtwork)
        self.trackLongDescription = try container.decode(String.self, forKey: .trackLongDescription)
        self.genre = try container.decode(String.self, forKey: .genre)
        self.currency = try container.decode(String.self, forKey: .currency)
        self.trackPrice = try container.decodeIfPresent(Decimal.self, forKey: .trackPrice)
        self.isFavorite = false // The value of this field is resolve after successfully pulling the data
    }
    
    init(trackId: Int64, trackName: String, trackArtwork: URL, trackLongDescription: String, genre: String, currency: String, trackPrice: Decimal?, isFavorite: Bool) {
        self.trackId = trackId
        self.trackName = trackName
        self.trackArtwork = trackArtwork
        self.trackLongDescription = trackLongDescription
        self.genre = genre
        self.currency = currency
        self.trackPrice = trackPrice
        self.isFavorite = isFavorite
    }
    
    private enum CodingKeys: String, CodingKey {
        case trackId = "trackId"
        case trackName
        case trackArtwork = "artworkUrl100"
        case trackLongDescription = "longDescription"
        case genre = "primaryGenreName"
        case currency = "currency"
        case trackPrice = "trackPrice"
    }
}

extension FetchedJam: Jammable {
    
    var jamID: Int64 {
        return self.trackId
    }
    
    var jamName: String {
        return self.trackName
    }
    
    var jamArtwork: URL {
        return self.trackArtwork
    }
    
    var jamDescription: String {
        return self.trackLongDescription
    }
    
    var jamGenre: String {
        return self.genre
    }
    
    var jamCurrency: String {
        return self.currency
    }
    
    var jamTrackPrice: Decimal? {
        return self.trackPrice
    }
}

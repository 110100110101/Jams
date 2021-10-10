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
    
    public var trackName: String
    public var trackArtwork: URL
    public var genre: String
    public var price: Decimal
    public var isFavorite: Bool
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.trackName = try container.decode(String.self, forKey: .trackName)
        self.trackArtwork = try container.decode(URL.self, forKey: .trackArtwork)
        self.genre = try container.decode(String.self, forKey: .genre)
        self.price = try container.decode(Decimal.self, forKey: .price)
        self.isFavorite = false
    }
    
    private enum CodingKeys: String, CodingKey {
        case trackName
        case trackArtwork
        case genre
        case price
    }
}
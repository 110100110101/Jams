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
    public var trackLongDescription: String
    public var trackShortDescription: String?
    public var genre: String
    public var isFavorite: Bool
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.trackName = try container.decode(String.self, forKey: .trackName)
        self.trackArtwork = try container.decode(URL.self, forKey: .trackArtwork)
        self.trackLongDescription = try container.decode(String.self, forKey: .trackLongDescription)
        self.trackShortDescription = try container.decodeIfPresent(String.self, forKey: .trackShortDescription)
        self.genre = try container.decode(String.self, forKey: .genre)
        self.isFavorite = false
    }
    
    private enum CodingKeys: String, CodingKey {
        case trackName
        case trackArtwork = "artworkUrl100"
        case trackLongDescription = "longDescription"
        case trackShortDescription = "shortDescription"
        case genre = "primaryGenreName"
    }
}

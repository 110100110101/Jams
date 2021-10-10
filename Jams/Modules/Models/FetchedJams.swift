//
//  FetchedJams.swift
//  Jams
//
//  Created by Jaja Yting on 10/10/21.
//

import Foundation

/**
 Object that represents the root object of iTunes Search API
 */
class FetchedJams: Decodable {
    
    public let jams: [FetchedJam]
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.jams = try container.decode([FetchedJam].self, forKey: .jams)
    }
}

private enum CodingKeys: String, CodingKey {
    case jams = "results"
}

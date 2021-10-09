//
//  ITunes.swift
//  Jams
//
//  Created by Jaja Yting on 10/9/21.
//

import Foundation
import Moya

enum ITunes {
    case search(parameters: [String : Any])
}

extension ITunes: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://itunes.apple.com")!
    }
    
    var path: String {
        return "/search"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .search(let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var sampleData: Data {
        return Data() // TODO: Try to simulate this
    }
}

//
//  JamsDataSource.swift
//  Jams
//
//  Created by Jaja Yting on 10/9/21.
//

import Foundation
import Moya
import RxSwift

final class JamsDataSource: JamsViewModelDataSource {
    
    typealias T = FetchedJam
    
    private let provider = MoyaProvider<ITunes>()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - JamsViewModelDataSource Methods
    
    func search(jam: String, completion: @escaping ([T]?, Error?) -> ()) {
            
        let parameters = ["term": jam,
                          "entity": "movie"]
        
        self.provider
            .rx
            .request(.search(parameters: parameters))
            .filterSuccessfulStatusCodes()
            .subscribe(onSuccess: { (response) in
                
                let decoder = JSONDecoder()
                do {
                    let fetchedJams = try decoder.decode(SearchResults.self, from: response.data)
                    completion(fetchedJams.jams, nil)
                }
                catch {
                    completion(nil, error)
                }
            }, onFailure: { (error) in
                completion(nil, error)
            })
            .disposed(by: self.disposeBag)
    }
    
    func toggleFavorite(_ isFavorite: Bool, jam: T) {
        // TODO: Toggle it
    }
}

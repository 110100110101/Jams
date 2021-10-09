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
    
    private let provider = MoyaProvider<ITunes>()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - JamsViewModelDataSource Methods
    
    func search(jam: String, completion: @escaping ([Any]?, Error?) -> ()) {
            
        let parameters = ["term": jam,
                          "entity": "movie"]
        
        self.provider
            .rx
            .request(.search(parameters: parameters))
            .filterSuccessfulStatusCodes()
            .subscribe(onSuccess: { (response) in
                // TODO: Decode the data
                completion([], nil)
            }, onFailure: { (error) in
                completion(nil, error)
            })
            .disposed(by: self.disposeBag)
    }
    
    func toggleFavorite(_ isFavorite: Bool, jam: Any) {
        // TODO: Toggle it
    }
}

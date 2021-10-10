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
    
    func search(jam: String, completion: @escaping ([FetchedJam]?, Error?) -> ()) {
            
        let parameters = ["term": jam,
                          "entity": "movie"]
        
        self.provider
            .rx
            .request(.search(parameters: parameters))
            .filterSuccessfulStatusCodes()
            .subscribe(onSuccess: { (response) in
                
                let decoder = JSONDecoder()
                do {
                    
                    let searchResults = try decoder.decode(SearchResults.self, from: response.data)
                    let fetchedJams = searchResults.jams
                    
                    CoreDataManager.sharedInstance.fetchAllFavoriteJams(completion: { [weak self] (favoriteJams, error) in
                        
                        if error != nil {
                            /*
                             Don't bother to match the data, if an error has occured while fetching the favorite jams
                             */
                            completion(fetchedJams, nil)
                        }
                        else if let favoriteJams = favoriteJams {
                            self?.matchFetchedJams(fetchedJams: fetchedJams,
                                                   fromFavoriteJams: favoriteJams,
                                                   completion: { (alignedFetchedJams) in
                                                    completion(alignedFetchedJams, nil)
                                                   })
                        }
                    })
                }
                catch {
                    completion(nil, error)
                }
            }, onFailure: { (error) in
                completion(nil, error)
            })
            .disposed(by: self.disposeBag)
    }
    
    func addJamToFavorites(_ jam: FetchedJam, completion: @escaping (Error?) -> ()) {
        CoreDataManager.sharedInstance.addFavoriteJam(jam: jam, completion: { (_, error) in
            completion(error)
        })
    }
    
    func removeJamToFavorites(_ jam: FetchedJam, completion: @escaping (Error?) -> ()) {
        
    }
    
    // MARK: - Private Methods
    
    /**
     Sets the `isFavorite` field to true of the `fetchedJams`, if their IDs was found on `favoriteJams`
     
     - parameter fetchedJams: Jams thats need an alignment with `isFavorite` field
     - parameter favoriteJams: List of jams where the data (isFavorite) will be come from
     - parameter completion: Invoked once the alignment was finished
     */
    private func matchFetchedJams(fetchedJams: [FetchedJam],
                                  fromFavoriteJams favoriteJams: [FavoriteJam],
                                  completion: @escaping ([FetchedJam]) -> ()) {
        
        DispatchQueue.global(qos: .userInteractive).async {
         
            // Create set of IDs from favorite jams
            
            let favoriteJamsIDs = Set(favoriteJams.map({ favoriteJam in
                return favoriteJam.jamID
            }))
            
            // Now, align the data
            
            for fetchedJam in fetchedJams {
                fetchedJam.isFavorite = favoriteJamsIDs.contains(fetchedJam.jamID)
            }
            
            // Dispatch it
            
            DispatchQueue.main.async {
                completion(fetchedJams)
            }
        }
    }
}

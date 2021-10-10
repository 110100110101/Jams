//
//  CoreDataManager.swift
//  Jams
//
//  Created by Jaja Yting on 10/10/21.
//

import Foundation
import CoreData
import RxCocoa

final class CoreDataManager {
    
    // MARK: - Singleton
    
    public static let sharedInstance = CoreDataManager()
    
    // MARK: - Fields
    
    /**
     Instance of persistent container that can be used in the app to manage core data.
     
     This can be also observed to validate its preparedness
     
     - Note: Will return `nil`, if the stack aren't ready yet
     */
    public let persistentContainer = BehaviorRelay<NSPersistentContainer?>(value: nil)
    private var _persistentContainer: NSPersistentContainer
        
    // MARK: - Initializer
    
    private init() {
        
        self._persistentContainer = NSPersistentContainer(name: "Jams")
        self._persistentContainer.loadPersistentStores(completionHandler: { [weak self] (description, error) in
            
            guard let self = self else {
                return
            }
            
            self.persistentContainer.accept(self._persistentContainer)
        })
    }
    
    // MARK: - Public Methods
    
    /**
     Fetch all the favorite jams of the user
     
     - parameter completion: Invoked whenever the items have been fetched or not.
     
     - Note: `completion` is invoked on main thread
     */
    public func fetchAllFavoriteJams(completion: @escaping ([FavoriteJam]?, Error?) -> ()) {
        
        guard let persistentContainer = self.persistentContainer.value else {
            DispatchQueue.main.async {
                let error = NSError(domain: "com.yting.Jams", code: 1000, userInfo: nil)
                completion(nil, error)
            }
            return
        }
        
        let backgroundContext = persistentContainer.newBackgroundContext()
        let fetchRequest: NSFetchRequest<FavoriteJam> = FavoriteJam.fetchRequest()
        let asynchronousFetchRequest = NSAsynchronousFetchRequest<FavoriteJam>(fetchRequest: fetchRequest) { result in
            
            if let error = result.operationError {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            
            guard let favoriteJams = result.finalResult else {
                
                DispatchQueue.main.async {
                    let error = NSError(domain: "com.yting.Jams", code: 1001, userInfo: nil)
                    completion(nil, error)
                }
                
                return
            }
            
            /*
             Instances of NSManagedObject from another queue must not be passed to another queue,
             so create instances of it using its objectID
             */
            
            DispatchQueue.main.async {
                
                var mainFavoriteJams = [FavoriteJam]()
                
                let mainContext = persistentContainer.viewContext
                for favoriteJam in favoriteJams {
                    
                    let objectID = favoriteJam.objectID
                    guard let mainFavoriteJam = mainContext.object(with: objectID) as? FavoriteJam else {
                        continue
                    }
                    
                    mainFavoriteJams.append(mainFavoriteJam)
                }
                
                completion(mainFavoriteJams, nil)
            }
        }
        
        do {
            try backgroundContext.execute(asynchronousFetchRequest)
        }
        catch {
            DispatchQueue.main.async {
                completion(nil, error)
            }
        }
    }
    
    /**
     Fetch favorite jam with given track ID
     
     - parameter completion: Invoked whenever the favorite jam have been fetched or not.
     If both values were `nil` means, there's no jam with that track ID
     
     - Note: `completion` is invoked on main thread
     */
    public func fetchFavoriteJam(withTrackID trackID: Decimal, completion: @escaping (FavoriteJam?, Error?) -> ()) {
        
        guard let persistentContainer = self.persistentContainer.value else {
            DispatchQueue.main.async {
                let error = NSError(domain: "com.yting.Jams", code: 1000, userInfo: nil)
                completion(nil, error)
            }
            return
        }
        
        let backgroundContext = persistentContainer.newBackgroundContext()
        
        let fetchRequest: NSFetchRequest<FavoriteJam> = FavoriteJam.fetchRequest()
        
        let predicate = NSPredicate(format: "trackId == %@", argumentArray: [NSDecimalNumber(decimal: trackID)])
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        
        let asynchronousFetchRequest = NSAsynchronousFetchRequest<FavoriteJam>(fetchRequest: fetchRequest) { result in
            
            if let error = result.operationError {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            
            guard let favoriteJam = result.finalResult?.first else {
                
                DispatchQueue.main.async {
                    let error = NSError(domain: "com.yting.Jams", code: 1001, userInfo: nil)
                    completion(nil, error)
                }
                
                return
            }
            
            /*
             Instances of NSManagedObject from another queue must not be passed to another queue,
             so create instances of it using its objectID
             */
            
            DispatchQueue.main.async {
                
                let mainContext = persistentContainer.viewContext
                
                let objectID = favoriteJam.objectID
                guard let mainFavoriteJam = mainContext.object(with: objectID) as? FavoriteJam else {
                    let error = NSError(domain: "com.yting.Jams", code: 1001, userInfo: nil)
                    completion(nil, error)
                    return
                }
                
                completion(mainFavoriteJam, nil)
            }
        }
        
        do {
            try backgroundContext.execute(asynchronousFetchRequest)
        }
        catch {
            DispatchQueue.main.async {
                completion(nil, error)
            }
        }
    }
    
    /**
     Marks the jam as a favorite
     
     - parameter jam: Jam that isn't added on the list yet
     - parameter completion: Invoked whenever the marking of jam as favorite was successful or not
     
     - Note: Adding the same jam isn't checked at this point, so multiple instances of same jam might be saved
     */
    public func addFavoriteJam(jam: Jammable, completion: @escaping (FavoriteJam?, Error?) -> ()) {
        
        guard let persistentContainer = self.persistentContainer.value else {
            let error = NSError(domain: "com.yting.Jams", code: 1000, userInfo: nil)
            completion(nil, error)
            return
        }
        
        let mainContext = persistentContainer.viewContext
        let entityDescription = FavoriteJam.entity()
        let favoriteJam = FavoriteJam(entity: entityDescription, insertInto: mainContext)
        
        favoriteJam.setValue(jam.jamGenre, forKey: "genre")
        favoriteJam.setValue(jam.jamArtwork, forKey: "trackArtwork")
        favoriteJam.setValue(jam.jamID, forKey: "trackId")
        favoriteJam.setValue(jam.jamDescription, forKey: "trackLongDescription")
        favoriteJam.setValue(jam.jamName, forKey: "trackName")
        
        do {
            try mainContext.save()
            completion(favoriteJam, nil)
        }
        catch {
            completion(nil, error)
        }
    }
    
    /**
     Deletes the favorite jam in store
     
     - parameter jam: Jam that gonna be deleted
     - parameter completion: Invoked whenever the deletion has been successful or not
     
     - Note: If there's no jam found in the store, it will still be considered as successful
     */
    public func deleteFavoriteJam(_ jam: Jammable, completion: @escaping (Error?) -> ()) {
        
        self.fetchFavoriteJam(withTrackID: jam.jamID, completion: { (favoriteJam, error) in
            
            if let error = error {
                completion(error)
            }
            else if let favoriteJam = favoriteJam {
          
                guard let persistentContainer = self.persistentContainer.value else {
                    let error = NSError(domain: "com.yting.Jams", code: 1000, userInfo: nil)
                    completion(error)
                    return
                }
                
                let mainContext = persistentContainer.viewContext
                mainContext.delete(favoriteJam)
                
                do {
                    try mainContext.save()
                    completion(nil)
                }
                catch {
                    completion(error)
                }
            }
            else {
                completion(nil)
            }
        })
    }
}

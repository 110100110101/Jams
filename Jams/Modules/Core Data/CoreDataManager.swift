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
}

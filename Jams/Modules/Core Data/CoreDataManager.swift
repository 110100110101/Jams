//
//  CoreDataManager.swift
//  Jams
//
//  Created by Jaja Yting on 10/10/21.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    // MARK: - Singleton
    
    public static let sharedInstance = CoreDataManager()
    
    // MARK: - Fields
    
    public let persistentContainer: NSPersistentContainer
    
    // MARK: - Initializer
    
    private init() {
        self.persistentContainer = NSPersistentContainer(name: "Jams")
    }
    
    // MARK: - Public Methods
    
    /**
     Fetch all the favorite jams of the user
     
     - parameter completion: Invoked whenever the items have been fetched or not.
     
     - Note: `completion` is invoked on main thread
     */
    public func fetchAllFavoriteJams(completion: @escaping ([FavoriteJam]?, Error?) -> ()) {
        
        let backgroundContext = self.persistentContainer.newBackgroundContext()
        
        let fetchRequest: NSFetchRequest<FavoriteJam> = FavoriteJam.fetchRequest()
        let asynchronousFetchRequest = NSAsynchronousFetchRequest<FavoriteJam>(fetchRequest: fetchRequest) { result in
            
            if let error = result.operationError {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            
            guard let favoriteJams = result.finalResult else {
                
                DispatchQueue.main.async {
                    let error = NSError(domain: "com.yting.Jams", code: 4000, userInfo: nil)
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
                
                let mainContext = self.persistentContainer.viewContext
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

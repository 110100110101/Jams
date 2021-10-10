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
}

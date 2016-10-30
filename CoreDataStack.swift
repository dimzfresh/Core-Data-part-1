//
//  CoreDataStack.swift
//  MealTime
//
//  Created by Dimz on 15.10.16.
//  Copyright © 2016 Dmitriy Zyablikov. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    let modelName = "MealTime"
    
    fileprivate lazy var appDocDir: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1]
    }()
    
    
    lazy var context: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    
    }()
    
    
    
    fileprivate lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
    
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.appDocDir.appendingPathComponent(self.modelName)
        
        do {
        
            let options = [NSMigratePersistentStoresAutomaticallyOption: true]
            try coordinator.addPersistentStore( ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            print("Can't add persistent store")
        }
    
    return coordinator
        
    }()
    
    
    fileprivate lazy var managedObjectModel: NSManagedObjectModel = {
    
        let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    
    
    func save() {
        if context.hasChanges {
            do{
                try context.save()
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
                abort()
            }
        }
    }
}

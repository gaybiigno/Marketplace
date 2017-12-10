//
//  CoreDataCommonMethods.swift
//  CoreDataForArtists
//
//  Created by AAK on 4/14/16.
//  Copyright © 2016 SSU. All rights reserved.
//

import UIKit
import CoreData

// See https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreData/InitializingtheCoreDataStack.html
// for more information about the need for creating varible manageObjectModel.

class CoreDataCommonMethods: NSObject {
    
    static var store = CoreDataStore()
    
    override init(){
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(CoreDataCommonMethods.contextDidSaveContext(_:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Return a managed object context that is tied to the persistent store that we have created.
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = CoreDataCommonMethods.store.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    lazy var backgroundContext: NSManagedObjectContext? = {

        var backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.persistentStoreCoordinator = CoreDataCommonMethods.store.persistentStoreCoordinator
        return backgroundContext
    }()
    

    func saveContext (_ context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                
                try context.save()
            } catch {
                // add appropriate code to provide a better feedback.
                NSLog("Unable to save context.")
                abort()
            }
        }
    }
    
    func saveContext () {
        self.saveContext( self.backgroundContext! )
    }
    
    @objc func contextDidSaveContext(_ notification: Notification) {
        let sender = notification.object as! NSManagedObjectContext
        if sender === self.managedObjectContext {
            self.backgroundContext!.perform {
                self.backgroundContext!.mergeChanges(fromContextDidSave: notification)
            }
        } else if sender === self.backgroundContext {
            self.managedObjectContext.perform {
                self.managedObjectContext.mergeChanges(fromContextDidSave: notification)
            }
        } else {
            self.backgroundContext!.perform {
                self.backgroundContext!.mergeChanges(fromContextDidSave: notification)
            }
            self.managedObjectContext.perform {
                self.managedObjectContext.mergeChanges(fromContextDidSave: notification)
            }
        }
    }
}

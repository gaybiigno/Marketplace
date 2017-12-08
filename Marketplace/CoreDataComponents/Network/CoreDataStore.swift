//
//  CoreDataStore.swift
//  CoreDataForArtists
//
//  Created by AAK on 4/14/16.
//  Copyright © 2016 SSU. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStore: NSObject {

    // See https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreData/InitializingtheCoreDataStack.html
    // for more information about the need for creating varible manageObjectModel.
    
    let storeName = "marketplace"
    let storeFilename = "marketplace.sqlite"
    
    lazy var applicationDocumentsDirectory: URL = {

        // Establish a path (url) to the application's document directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // Establish a pointer to DB Model that is defined in CoreDataForArtists.xcdatamodeld.
        if let modelURL = Bundle.main.url(forResource: self.storeName, withExtension: "momd") {
            return NSManagedObjectModel(contentsOf: modelURL)!
        }
        abort() // should do something more appropriate here...
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // Create the coordinator and store configure it.
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent(self.storeFilename)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            NSLog("Unable to tie the store with the coordinator")
            abort()
        }
        
        return coordinator
    }()
}

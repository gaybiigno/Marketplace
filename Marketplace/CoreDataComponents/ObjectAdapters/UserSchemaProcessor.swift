//
//  UserSchemaProcessor.swift
//
//  Created by RCG on 12/5/17.
//

import UIKit
import CoreData

class UserSchemaProcessor: NSObject {
    
    let userModelJSONString: [AnyObject]
    let coreDataContext = CoreDataCommonMethods()
    
    init(userModelJSON: [AnyObject]) {
        userModelJSONString = userModelJSON
        super.init()
        deleteAllUsers()
        processJSON(userModelJSON)
    }
    
    func processJSON(_ schema: [AnyObject]) {
        for entity in schema {
            if let result = entity["result"] {
                let objects = result as! [AnyObject]
                    processUsersJSON(objects)
            }
        }
    }
    
    func fetchAllUsers() {
        let fReq = NSFetchRequest<NSFetchRequestResult>()
        fReq.returnsObjectsAsFaults = false
        do {
            let result = try coreDataContext.managedObjectContext.fetch(fReq)
            let users = result as! [User]
            print("Printing emails of all users")
            for user in users {
                var toPrint = ""
                if let title = user.email {
                    toPrint += title + " "
                }
                print(toPrint)
            }
        } catch {
            print("Unable to fetch all users from the database.")
            abort()
        }
    }
    
    func getAllUsers() -> [User]? {
        let fReq = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fReq.returnsObjectsAsFaults = false
        do {
            let result = try coreDataContext.managedObjectContext.fetch(fReq)
            return result as? [User]
        } catch {
            NSLog("Unable to fetch Users from the database.")
            abort()
        }
        return nil
    }
    
    
    
    func deleteAllUsers() {
        let fReq = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fReq.returnsObjectsAsFaults = false
        do {
            let results = try coreDataContext.managedObjectContext.fetch(fReq)
            for result in results {
                let r = try coreDataContext.managedObjectContext.delete(result as! NSManagedObject)
            }
        } catch {
            abort()
        }
    }
    
    func processUsersJSON(_ userObjects: [AnyObject]) {
        for userObject in userObjects {
            if let userDict = userObject as? Dictionary<String, AnyObject> {
                let user = NSEntityDescription.insertNewObject(forEntityName: "User", into:
                    coreDataContext.backgroundContext!) as! User
                
                if let email = userDict["email"] {
                    user.email = email as? String
                }
                if let first_name = userDict["first_name"] {
                    user.first_name = first_name as? String
                }
                if let last_name = userDict["last_name"] {
                    user.last_name = last_name as? String
                }
                if let bday = userDict["bday"] {
                    user.bday = (bday as? String)
                }
                if let bmonth = userDict["bmonth"] {
                    user.bmonth = (bmonth as? String)
                }
                if let byear = userDict["byear"] {
                    user.byear = (byear as? String)
                }
                if let street = userDict["street"] {
                    user.street = street as? String
                }
                if let city = userDict["city"] {
                    user.city = city as? String
                }
                if let state = userDict["state"] {
                    user.state = state as? String
                }
                if let zip = userDict["zip"] {
                    user.zip = zip as? String
                }
                if let rating = userDict["rating"] {
                    user.rating = (rating as? Int16)!
                }
                if let payment = userDict["payment"] {
                    user.payment = payment as? String
                }
                
            }
        }
        coreDataContext.saveContext();
    }
}

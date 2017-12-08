//
//  UserSchemaProcessor.swift
//
//  Created by RCG on 12/5/17.
//

import UIKit
import CoreData

class UsertemSchemaProcessor: NSObject {
    
    let userModelJSONString: [AnyObject]
    let coreDataContext = CoreDataCommonMethods()
    
    init(userModelJSON: [AnyObject]) {
        userModelJSONString = userModelJSON
        super.init()
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
        let sorter = NSSortDescriptor(key: "user_email", ascending: false)
        fReq.sortDescriptors = [sorter]
        fReq.returnsObjectsAsFaults = false
        do {
            let result = try coreDataContext.managedObjectContext.fetch(fReq)
            return result as? [User]
        } catch {
            NSLog("Unable to fetch Artist from the database.")
            abort()
        }
        return nil
    }
    
    func processUsersJSON(_ userObjects: [AnyObject]) {
        for userObject in userObjects {
            if let userDict = userObject as? Dictionary<String, AnyObject> {
                let user = NSEntityDescription.insertNewObject(forEntityName: "User", into:
                    coreDataContext.backgroundContext!) as! User
                
                if let first_name = userDict["first_name"] {
                    user.first_name = first_name as? String
                }
                if let last_name = userDict["last_name"] {
                    user.last_name = last_name as? String
                }
                if let bday = userDict["bday"] {
                    user.bday = (bday as? Int16)!
                }
                if let bmonth = userDict["bmonth"] {
                    user.bmonth = (bmonth as? Int16)!
                }
                if let byear = userDict["byear"] {
                    user.byear = (byear as? Int16)!
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

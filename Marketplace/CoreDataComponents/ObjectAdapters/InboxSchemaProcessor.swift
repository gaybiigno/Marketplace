//
//  InboxSchemaProcessor.swift
//  Marketplace
//
//  Created by student on 12/10/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

import CoreData

class InboxSchemaProcessor: NSObject {

    let inboxModelJSONString: [AnyObject]
    let coreDataContext = CoreDataCommonMethods()
    
    init(inboxModelJSON: [AnyObject]) {
        inboxModelJSONString = inboxModelJSON
        super.init()
        deleteAllInboxs()
        processJSON(inboxModelJSON)
    }
    
    func processJSON(_ schema: [AnyObject]) {
        for entity in schema {
            if let result = entity["result"] {
                let objects = result as! [AnyObject]
                processInboxJSON(objects)
            }
        }
    }
    
    func fetchForRecipient(_ recipient: String) -> [Inbox]? {
        let fReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Inbox")
        let pred = NSPredicate(format: "recipient_email = %@", recipient)
        let sorter = NSSortDescriptor(key: "msg_id", ascending: false)
        fReq.sortDescriptors = [sorter]
        fReq.returnsObjectsAsFaults = false
        do {
            let result = try coreDataContext.managedObjectContext.fetch(fReq)
            let i = (result as NSArray).filtered(using: pred)
            print(i)
            return i as? [Inbox]
        } catch {
            NSLog("Unable to fetch Inbox from the database.")
            abort()
        }
        return nil
    }
    
    func fetchAllInboxs() {
        let fReq = NSFetchRequest<NSFetchRequestResult>()
        fReq.returnsObjectsAsFaults = false
        do {
            let result = try coreDataContext.managedObjectContext.fetch(fReq)
            let inboxs = result as! [Inbox]
            print("Printing subjects of all Inboxs")
            for inbox in inboxs {
                var toPrint = ""
                if let title = inbox.subject {
                    toPrint += title + " "
                }
                print(toPrint)
            }
        } catch {
            print("Unable to fetch all inboxs from the database.")
            abort()
        }
    }
    
    func getAllInboxs() -> [Inbox]? {
        let fReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Inbox")
        let sorter = NSSortDescriptor(key: "msg_id", ascending: false)
        fReq.sortDescriptors = [sorter]
        fReq.returnsObjectsAsFaults = false
        do {
            let result = try coreDataContext.managedObjectContext.fetch(fReq)
            return result as? [Inbox]
        } catch {
            NSLog("Unable to fetch Inbox from the database.")
            abort()
        }
        return nil
    }
    
    func deleteAllInboxs() {
        let fReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Inbox")
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
    
    func processInboxJSON(_ inboxObjects: [AnyObject]) {
        for inboxObject in inboxObjects {
            if let inboxDict = inboxObject as? Dictionary<String, AnyObject> {
                let inbox = NSEntityDescription.insertNewObject(forEntityName: "Inbox", into:
                    coreDataContext.backgroundContext!) as! Inbox
                
                if let recipient_email = inboxDict["recipient_email"] {
                    inbox.recipient_email = (recipient_email as? String)!
                }
                if let sender_email = inboxDict["sender_email"] {
                    inbox.sender_email = sender_email as? String
                }
                if let msg_id = inboxDict["msg_id"] {
                    inbox.msg_id = msg_id as? NSNumber
                }
                if let message = inboxDict["message"] {
                    inbox.message = message as? String
                }
                if let subject = inboxDict["subject"] {
                    inbox.subject = subject as? String
                }
            }
        }
        coreDataContext.saveContext();
    }
    
}

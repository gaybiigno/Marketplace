//
//  FunctionSchemaProcessor.swift
//  Marketplace
//
//  Created by student on 12/8/17.
//  Copyright © 2017 SSU. All rights reserved.
//
import UIKit
import CoreData

class FunctionSchemaProcessor: NSObject {
    let response: [AnyObject]
    var accepted: Bool = false
    
    init(responseJSON: [AnyObject]) {
        response = responseJSON
        super.init()
        processJSON(response)
    }
    
    func processJSON(_ schema: [AnyObject]) {
        for entity in schema {
            if let result = entity["result"] {
                let objects = result as! [AnyObject]
                processResponseJSON(objects)
            }
        }
    }
    
    func processResponseJSON(_ responseObjects: [AnyObject]) {
        for responseObject in responseObjects {
            if let responseDict = responseObject as? Dictionary<String, AnyObject> {
                var verify: Int
                if let verified = responseDict["verified"] {
                    verify = (verified as? Int)!
                    if verify == 1 {
                        accepted = true
                    } else {
                        accepted = false
                    }
                }
                //let user = NSEntityDescription.insertNewObject(forEntityName: "User", into:
                //coreDataContext.backgroundContext!) as! User
                
                //                if let first_name = userDict["first_name"] {
                //                    user.first_name = first_name as? String
                //                }
                
            }
        }
        //coreDataContext.saveContext();
    }
    
    func getResponse() -> Bool? {
        return accepted
    }
}


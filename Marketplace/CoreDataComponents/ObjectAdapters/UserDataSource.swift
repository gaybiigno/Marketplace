//
//  UserDataSource.swift
//  Marketplace
//
//  Created by RCG on 12/7/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class UserDataSource: NSObject {
    
    var users: [User]?
    
    init(dataSource: [User]?) {
        users = dataSource
        print(users!)
        print(dataSource!.count)
        
        super.init()
    }
    
    func numUsers() -> Int{
        if users == nil {
            return 0
        }
        return users!.count
    }
    
    func userAt(_ index: Int) -> User? {
        if users == nil || index > users!.count {
            return nil
        }
        return users?[index]
    }
    
    func consolidate() {
        var previd = ""
        var curIdx = 0
        for user in users! {
            if user.email != nil {
                if user.email == previd {
                    users?.remove(at: curIdx)
                } else {
                    curIdx = curIdx + 1
                    previd = user.email!
                }
            } else {
                users?.remove(at: curIdx)
            }
        }
    }
    
}



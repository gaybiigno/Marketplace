//
//  InboxDataSource.swift
//  Marketplace
//
//  Created by student on 12/10/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class InboxDataSource: NSObject {

    var inboxs: [Inbox]?
    
    init(dataSource: [Inbox]?) {
        inboxs = dataSource
        super.init()
    }
    
    func numInboxs() -> Int{
        if inboxs == nil {
            return 0
        }
        return inboxs!.count
    }
    
    func inboxAt(_ index: Int) -> Inbox? {
        if inboxs == nil || index > inboxs!.count {
            return nil
        }
        return inboxs?[index]
    }
    
    func consolidate() {
        var previd = -1
        var curIdx = 0
        for inbox in inboxs! {
            if Int(truncating: inbox.msg_id!) == previd || inbox.msg_id == nil {
                inboxs?.remove(at: curIdx)
            } else {
                curIdx = curIdx + 1
                previd = Int(truncating: inbox.msg_id!)
            }
        }
    }
    
}

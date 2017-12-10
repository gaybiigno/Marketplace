//
//  ItemDataSource.swift
//  Marketplace
//
//  Created by RCG on 12/6/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class ItemDataSource: NSObject {
    
    var items: [Item]?
    
    init(dataSource: [Item]?) {
        items = dataSource
//        print(items!)
//        print(dataSource!.count)
        
        super.init()
    }
    
    func numItems() -> Int{
        if items == nil {
            return 0
        }
        return items!.count
    }
    
    func itemAt(_ index: Int) -> Item? {
        if items == nil || index > items!.count {
            return nil
        }
        return items?[index]
    }
    
    func consolidate() {
        var previd = -1
        var curIdx = 0
        for item in items! {
            if item.item_id == previd {
                items?.remove(at: curIdx)
            } else {
                curIdx = curIdx + 1
                previd = Int(item.item_id)
            }
        }
    }
    
}


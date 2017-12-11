//
//  TagsDataSource.swift
//  Marketplace
//
//  Created by student on 12/11/17.
//  Copyright © 2017 SSU. All rights reserved.
//
import UIKit

class TagsDataSource: NSObject {
    
    var tags: [Tags]?
    
    init(dataSource: [Tags]?) {
        tags = dataSource
        //        print(items!)
        //        print(dataSource!.count)
        
        super.init()
    }
    
    func numTags() -> Int {
        if tags == nil {
            return 0
        }
        return tags!.count
    }
    
    func tagAt(_ index: Int) -> Tags? {
        if tags == nil || index > tags!.count {
            return nil
        }
        return tags?[index]
    }
    
    func consolidate() {
        var previd = ""
        var curIdx = 0
        for tag in tags! {
            if tag.tag == previd {
                tags?.remove(at: curIdx)
            } else {
                curIdx = curIdx + 1
                previd = tag.tag!
            }
        }
    }
    
}

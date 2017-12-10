//
//  FunctionDataSource.swift
//  Marketplace
//
//  Created by student on 12/8/17.
//  Copyright © 2017 SSU. All rights reserved.
//
import UIKit

class FunctionDataSource: NSObject {
    
    var response: Int?
    
    init(dataSource: Int?) {
        response = dataSource
        print(response)
        
        super.init()
    }
    
    func getResponse() -> Int? {
        return response
    }
}

//
//  Download.swift
//  Navigation
//
//  Created by AAK on 3/10/16.
//  Copyright © 2016 SSU. All rights reserved.
//

import UIKit

class Download: NSObject {
    
    static let baseURL = "http://localhost:3306"
    static let apikey = "2747808961751484"
    
    var urlString: String
    @objc dynamic var dataFromServer: AnyObject?
    
    init(withURLString: String) {
        urlString = withURLString
        super.init()
    }
    
    func download_request()
    {
        
        if let url = URL(string: urlString) {
            do {
                var contents = try String(contentsOf: url)
                contents = makeJsonArray(string: contents)
                if let data = contents.data(using: .utf8) {
                    dataFromServer = try! JSONSerialization.jsonObject(with: data, options: []) as! AnyObject
                }
            } catch {
                // contents could not be loaded
            }
        } else {
            // the URL was bad!
        }
    }
    
    func makeJsonArray(string: String) -> String {
        let newString = "[" + string + "]"
        return newString
    }
}

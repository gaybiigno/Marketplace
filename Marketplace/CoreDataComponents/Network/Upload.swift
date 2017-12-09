//
//  Upload.swift
//  Marketplace
//
//  Created by RCG on 12/8/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class Upload: NSObject {
    
    static let baseURL = "http://localhost:8181"
    static let apikey = "2747808961751484"
    
    var urlString: String
    @objc dynamic var dataFromServer: AnyObject?
    
    init(withURLString: String) {
        urlString = withURLString
        super.init()
    }
    
    func upload_request()
    {
        if let url = URL(string: urlString) {
            do {
                var contents = try String(contentsOf: url)
                contents = makeJsonArray(string: contents)
                if let data = contents.data(using: .utf8) {
                    try! JSONSerialization.jsonObject(with: data, options: []) as! AnyObject
                }
            } catch {
                // contents could not be loaded
                print("contents can't load")
            }
        } else {
            print("bad url!!!!")
            // the URL was bad!
        }
    }
    
    func makeJsonArray(string: String) -> String {
        let newString = "[" + string + "]"
        return newString
    }
}


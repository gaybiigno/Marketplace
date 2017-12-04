//
//  UserModel.swift
//  Marketplace
//
//  Created by Gaybriella Igno on 11/14/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class UserModel: NSObject {
	
	fileprivate let ninjaPic = "https://cdn1.iconfinder.com/data/icons/ninja-things-1/1772/ninja-simple-512.png"
    
    // TODO TEMP
	func numUserItems() -> Int {
		return 10
	}
	
    // TODO TEMP
	func getUserName() -> String {
		return "Jane D."
	}
	
	func getRating() -> Float {
		var rating = 7.589  // TODO TEMP
		rating = (rating * 10).rounded() / 10
		return Float(rating)
	}
	
	func getProfilePic() -> UIImage? {
		if let url = URL(string: ninjaPic), let data = try? Data(contentsOf: url),
			let image = UIImage(data: data) {
			return image
		} else { // If user has not uploaded profile picture
			return defaultProfilePic()
		}
	}
	
    func defaultProfilePic() -> UIImage? {
        return UIImage(named: "DefaultProfileIcon")!
    }
	
	
}

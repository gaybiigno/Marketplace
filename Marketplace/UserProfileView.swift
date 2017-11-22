//
//  UserProfileView.swift
//  Marketplace
//
//  Created by Gaybriella Igno on 11/8/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class UserProfileView: UIViewController {
	
	@IBOutlet weak var profilePicture: UIImageView!
	@IBOutlet weak var username: UILabel!
	@IBOutlet weak var rating: UILabel!
	
	
	let userData = UserModel()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		start()
		
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func start() {
		setUserName()
		setRating()
		setProfilePic()
	}
	
	func setUserName() {
		username.text = userData.getUserName()
	}
	
	func setRating() {
		rating.text = String(describing: userData.getRating())
	}
	
	func setProfilePic() {
		if let image = userData.getProfilePic() {
			profilePicture.image = image
			profilePicture.layer.cornerRadius = 5.0
			profilePicture.layer.masksToBounds = true
		}
	}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

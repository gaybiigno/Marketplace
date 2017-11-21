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
	
	
	var userData: UserModel?
	
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
		print("we out here")
		title = userData?.getUserName()
		
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

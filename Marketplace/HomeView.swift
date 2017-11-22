//
//  HomeView.swift
//  Marketplace
//
//  Created by Gaybriella Igno on 11/6/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class HomeView: UIViewController {
	
	@IBOutlet weak var scrollView: UIScrollView!
	
	@IBOutlet weak var helloLabel: UILabel!
	
	@IBOutlet weak var registerButton: UIButton!
	@IBOutlet weak var signInButton: UIButton!
	
	@IBOutlet weak var homeGardButton: UIButton!
	@IBOutlet weak var fashionButton: UIButton!
	@IBOutlet weak var electronicsButton: UIButton!
	@IBOutlet weak var artCollectButton: UIButton!
	@IBOutlet weak var autoVehiButton: UIButton!
	@IBOutlet weak var sportingButton: UIButton!
	
	@IBOutlet weak var navBar: UINavigationItem!
	
	let userData = UserModel()
	
	var signedIn = false
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		startValues()
		scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+10)
		
		//checkUser()
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func startValues() {
		// Add targets
		registerButton.addTarget(self, action: #selector(clickRegister(_:)), for: .touchUpInside)
		
		signInButton.addTarget(self, action: #selector(clickSignIn(_:)), for: .touchUpInside)
		
		// Add borders
		let borderColor = homeGardButton.backgroundColor?.cgColor
		fashionButton.layer.borderWidth = 1.0
		fashionButton.layer.borderColor = borderColor
		artCollectButton.layer.borderWidth = 1.0
		artCollectButton.layer.borderColor = borderColor
		sportingButton.layer.borderWidth = 1.0
		sportingButton.layer.borderColor = borderColor // as! CGColor
		
		if signedIn {
			addHello()
		}
	}
	
	@objc func clickRegister(_ sender: UIButton) {
		self.performSegue(withIdentifier: "homeToReg", sender: self)
	}
	
	@objc func clickSignIn(_ sender: UIButton) {
		self.performSegue(withIdentifier: "homeToSignIn", sender: self)
	}
	
	func addHello() {
		signInButton.isHidden = true
		registerButton.isHidden = true
		
		let username = userData.getUserName()
		helloLabel.text = "Hello, " + username
		helloLabel.isHidden = false
	}
	
	

	/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "homeToReg" {
			if let destination = segue.destination as? RegisterTableView {
				
			}
		}
		
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
	*/

}

//
//  HomeView.swift
//  Marketplace
//
//  Created by Gaybriella Igno on 11/6/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

protocol SegueHandler: class {
	func segueToNext(identifier: String)
	
	func signOut()
}

class HomeView: UIViewController, SegueHandler {
	
	@IBOutlet weak var scrollView: UIScrollView!
	
	@IBOutlet weak var helloLabel: UILabel!
	@IBOutlet weak var registerButton: UIButton!
	@IBOutlet weak var signInButton: UIButton!
	
	@IBOutlet weak var menuButton: UIButton!
	
	@IBOutlet weak var homeGardButton: UIButton!
	@IBOutlet weak var fashionButton: UIButton!
	@IBOutlet weak var electronicsButton: UIButton!
	@IBOutlet weak var artCollectButton: UIButton!
	@IBOutlet weak var autoVehiButton: UIButton!
	@IBOutlet weak var sportingButton: UIButton!
	
	@IBOutlet weak var navBar: UINavigationItem!
	
	@IBOutlet weak var viewForMenu: UIView!
	
	private var embeddedViewController: MenuTableView!
	
	let userData = UserModel()
	let darkView = UIView()
	
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
		self.view.backgroundColor = UIColor.white
		
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
		sportingButton.layer.borderColor = borderColor
		
		if signedIn {
			addHello()
		} else {
			menuButton.isHidden = true
			helloLabel.isHidden = true
		}
	}
	
	func addHello() {
		signInButton.isHidden = true
		registerButton.isHidden = true
		
		let username = userData.getUserName()
		helloLabel.text = "Hello, " + username
		helloLabel.isHidden = false
		
		menuButton.isHidden = false
		menuButton.addTarget(self, action: #selector(clickMenu(_:)), for: .touchUpInside)
	}
	
	func signOut() {
		if !signedIn {
			print("ERROR: Cannot sign out of NULL profile")
			return
		}
		endMenu(self)
		
		menuButton.isHidden = true
		helloLabel.isHidden = true
		
		signInButton.isHidden = false
		registerButton.isHidden = false
		
		signedIn = false
	}
	
	@objc func clickRegister(_ sender: UIButton) {
		self.performSegue(withIdentifier: "homeToReg", sender: self)
	}
	
	@objc func clickSignIn(_ sender: UIButton) {
		self.performSegue(withIdentifier: "homeToSignIn", sender: self)
	}
	
	@objc func clickMenu(_ sender: UIButton) {
		if viewForMenu.isHidden {
			self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endMenu)))
			viewForMenu.isHidden = false
		} else {
			viewForMenu.isHidden = true
		}
	}
	
	@objc func endMenu(_ sender: HomeView) {
		viewForMenu.isHidden = true
	}
	
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let vc = segue.destination as? MenuTableView,
			segue.identifier == "showMenu" {
			vc.delegate = self
			self.embeddedViewController = vc
		}
	}
	
	func segueToNext(identifier: String) {
		self.performSegue(withIdentifier: identifier, sender: self)
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

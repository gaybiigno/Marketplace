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

class HomeView: UIViewController, SegueHandler, UISearchBarDelegate {
	
	@IBOutlet weak var scrollView: UIScrollView!
	
	@IBOutlet weak var mainText: UITextView!
	@IBOutlet weak var shopByLabel: UILabel!
	
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
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var viewForMenu: UIView!
    @IBOutlet weak var searchOptionsButton: UIButton!
	
	private var embeddedViewController: MenuTableView!
    
    private let categories = ["", "Home & Garden", "Fashion", "Electronics", "Art & Collectibles", "Auto & Vehicles", "Sporting Goods"]
    
    private var category = ""
	
	let userData = UserModel()
    
    var curEmail: String!
    var currentUser: User!
    
    var downloadAssistant: Download! = nil
	
	var uName: String!
	
	var signedIn = false
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		startValues()
		self.view.backgroundColor = UIColor.white
		scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+10)
        searchBar.delegate = self
		
		searchBorders()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		if curEmail != nil {
            signedIn = true
			downloadAssistant = Download(withURLString: buildURLString())
			downloadAssistant.addObserver(self, forKeyPath: "dataFromServer", options: .old, context: nil)
			downloadAssistant.download_request()
		} else {
			signedIn = false
		}
	}
	
	func buildURLString() -> String {
		var url = Download.baseURL
		url += "/users/"
		url += "?email=" + curEmail
		url += "&apikey=" + Download.apikey
		return url
	}
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		let userSchema = UserSchemaProcessor(userModelJSON: downloadAssistant.dataFromServer! as! [AnyObject])
		let userDataSource = UserDataSource(dataSource: userSchema.getAllUsers())
		userDataSource.consolidate()
		currentUser = userDataSource.userAt(0)
		addHello()
        downloadAssistant.removeObserver(self, forKeyPath: "dataFromServer")
	}
	
	func searchBorders() {
		searchOptionsButton.layer.borderColor = UIColor.black.cgColor
		searchOptionsButton.layer.borderWidth = 0.2
		searchBar.layer.borderColor = UIColor.black.cgColor
		searchBar.layer.borderWidth = 0.2
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func startValues() {
		uName = uName == nil ? userData.getUserName() : uName
		
		// Set place of menu
		let topY = searchBar.frame.minY
		viewForMenu.frame.origin = CGPoint(x: 50, y: topY)
		
		// Add targets
		registerButton.addTarget(self, action: #selector(clickRegister(_:)), for: .touchUpInside)
		signInButton.addTarget(self, action: #selector(clickSignIn(_:)), for: .touchUpInside)
        homeGardButton.addTarget(self, action: #selector(searchHomeGarden(_:)), for: .touchUpInside)
		fashionButton.addTarget(self, action: #selector(searchFashion(_:)), for: .touchUpInside)
		electronicsButton.addTarget(self, action: #selector(searchElectronics(_:)), for: .touchUpInside)
		artCollectButton.addTarget(self, action: #selector(searchArtCollect(_:)), for: .touchUpInside)
		autoVehiButton.addTarget(self, action: #selector(searchAutoVehicle(_:)), for: .touchUpInside)
		sportingButton.addTarget(self, action: #selector(searchSportingGoods(_:)), for: .touchUpInside)
		
		// Add borders
		let borderColor = homeGardButton.backgroundColor?.cgColor
		viewForMenu.layer.borderColor = borderColor
		viewForMenu.layer.borderWidth = 0.8
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
		
        curEmail = currentUser.email
        helloLabel.text = "Hello, " + currentUser.first_name! + " " + currentUser.last_name![0] + "."
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
		
        currentUser = nil
		signedIn = false
	}

    @objc func searchHomeGarden(_ sender: UIButton) {
        self.performSegue(withIdentifier: "searchStart", sender: self)
        category = categories[1]
    }
    
    @objc func searchFashion(_ sender: UIButton) {
        self.performSegue(withIdentifier: "searchStart", sender: self)
        category = categories[2]
    }
    
    @objc func searchElectronics(_ sender: UIButton) {
        self.performSegue(withIdentifier: "searchStart", sender: self)
        category = categories[3]
    }
    
    @objc func searchArtCollect(_ sender: UIButton) {
        self.performSegue(withIdentifier: "searchStart", sender: self)
        category = categories[4]
    }
    
    @objc func searchAutoVehicle(_ sender: UIButton) {
        self.performSegue(withIdentifier: "searchStart", sender: self)
        category = categories[5]
    }
    
    @objc func searchSportingGoods(_ sender: UIButton) {
        self.performSegue(withIdentifier: "searchStart", sender: self)
        category = categories[6]
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
	
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.performSegue(withIdentifier: "searchStart", sender: self)
        return true
    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let vc = segue.destination as? MenuTableView,
			segue.identifier == "showMenu" {
			vc.delegate = self
			self.embeddedViewController = vc
		}
        else if let vc = segue.destination as? SearchTableView,
            segue.identifier == "searchStart" {
			endMenu(self)
			print("guestBrowsing in home:", !signedIn)
			vc.guestBrowsing = !signedIn
            vc.searchParams = true
			//vc.keyWords = category
            vc.category = category.isEmpty ? nil : category
            vc.currentUserEmail = curEmail
            vc.filterContentForSearchText(category)
        }
		else if let vc = segue.destination as? EditProfileView,
			segue.identifier == "homeToEditProf" {
			endMenu(self)
			let name = uName.components(separatedBy: " ")
			vc.firstName = name[0]
			vc.lastName = name[1]
            vc.curEmail = curEmail
            vc.hasVal = true
            vc.currentUser = currentUser
		}
        else if let vc = segue.destination as? UploadItemTableView,
            segue.identifier == "homeToUp" {
            vc.currentEmail = curEmail
        }
            
        else if let vc = segue.destination as? InboxTableView,
            segue.identifier == "homeToInbox" {
            endMenu(self)
            vc.thisUserEmail = curEmail
        }
        else if let vc = segue.destination as? SearchParametersTableView,
            segue.identifier == "toSearchParams" {
            endMenu(self)
            vc.guestBrowsing = !signedIn
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

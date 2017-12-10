//
//  SignInTableView.swift
//  Marketplace
//
//  Created by Gaybriella Igno on 11/9/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class SignInTableView: UITableViewController {

	@IBOutlet weak var email_entry: UITextField!
	@IBOutlet weak var password_entry: UITextField!
	
	@IBOutlet weak var errorMessage: UITextView!
	
	@IBOutlet weak var enterButton: UIButton!
	
	let userInfo = UserModel()
    
    var downloadAssistant: Download! = nil
    
    var functionSchema: FunctionSchemaProcessor!
    var functionDataSource: FunctionDataSource? = nil
    
    var curUser: User! = nil
    var signedIn: Bool = false
	
	override func viewDidLoad() {
        super.viewDidLoad()
		errorMessage.isHidden = true
        email_entry.autocorrectionType = .no
        password_entry.autocorrectionType = .no
		self.view.backgroundColor = UIColor.white
		
		enterButton.frame.size = CGSize(width: view.frame.width, height: 45)
    }
	
	@IBAction func clickedBack(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func submit(_ sender: UIButton) {
		if (email_entry.text?.isEmpty)! || (password_entry.text?.isEmpty)! {
			errorMessage.isHidden = false
			email_entry.text = ""
			password_entry.text = ""
		} else {
            downloadAssistant = Download(withURLString: buildSubmissionURL(typeOfSubmission: "verify"))
            downloadAssistant.addObserver(self, forKeyPath: "dataFromServer", options: .old, context: nil)
            downloadAssistant.verify_request()
		}
		// TODO:: If they aren't empty, do something with input
	}
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if signedIn == false {
            functionSchema = FunctionSchemaProcessor(responseJSON: downloadAssistant.dataFromServer! as! [AnyObject])
            let check = functionSchema.accepted
            if check == true {
                signedIn = true
                errorMessage.isHidden = true
                getCurrentUser()
                //self.performSegue(withIdentifier: "completeSignIn", sender: self)
            } else {
                errorMessage.isHidden = false
                //wrong password prompt
            }
        } else {
            let userSchema = UserSchemaProcessor(userModelJSON: downloadAssistant.dataFromServer! as! [AnyObject])
            var userss = userSchema.getAllUsers()
            let user = userss![0]
            let userDataSource = UserDataSource(dataSource: userSchema.getAllUsers())
            userDataSource.consolidate()
            curUser = userDataSource.userAt(0)
            //print(curUser)
            let name = curUser.first_name
            self.performSegue(withIdentifier: "completeSignIn", sender: self)
        }
        
    }
    
    func getCurrentUser() {
        downloadAssistant.removeObserver(self, forKeyPath: "dataFromServer", context: nil)
        downloadAssistant = Download(withURLString: buildSubmissionURL(typeOfSubmission: "user"))
        downloadAssistant.addObserver(self, forKeyPath: "dataFromServer", options: .old, context: nil)
        downloadAssistant.download_request()
    }
    
    deinit {
        downloadAssistant.removeObserver(self, forKeyPath: "verifyDataFromServer", context: nil)
        downloadAssistant.removeObserver(self, forKeyPath: "userDataFromServer", context: nil)
    }

    func buildSubmissionURL(typeOfSubmission: String) -> String {
        var url = Download.baseURL + "/users"
        if (typeOfSubmission == "verify") {
            url = url + "/verify?"
            url = url + "email=" + email_entry.text!
            url = url + "&password=" + password_entry.text!
            url = url + "&apikey=" + Download.apikey
        } else if (typeOfSubmission == "user") {
            url = url + "/?"
            url = url + "email=" + email_entry.text!
            url = url + "&password=" + password_entry.text!
            url = url + "&apikey=" + Download.apikey
        }
        return url
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "completeSignIn" {
			if segue.destination is HomeView {
				let hv = segue.destination as! HomeView
				hv.signedIn = true
                hv.currentUser = curUser
			}
		}
		print("should be signed in")
    }
	

}

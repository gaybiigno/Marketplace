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
	
	let userInfo = UserModel()
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
		errorMessage.isHidden = true
		self.view.backgroundColor = UIColor.white
    }
	
	@IBAction func submit(_ sender: UIButton) {
		if (email_entry.text?.isEmpty)! || (password_entry.text?.isEmpty)! {
			errorMessage.isHidden = false
			email_entry.text = ""
			password_entry.text = ""
		} else {
			self.performSegue(withIdentifier: "completeSignIn", sender: self)
		}
		// TODO:: If they aren't empty, do something with input
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
			}
		}
		print("should be signed in")
    }
	

}

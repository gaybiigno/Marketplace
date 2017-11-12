//
//  RegisterTableView.swift
//  Marketplace
//
//  Created by Gaybriella Igno on 11/9/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class RegisterTableView: UITableViewController {
	
	@IBOutlet weak var firstName: UITextField!
	@IBOutlet weak var lastName: UITextField!
	
	@IBOutlet weak var email: UITextField!
	@IBOutlet weak var password: UITextField!
	@IBOutlet weak var confirmPassword: UITextField!
	
	@IBOutlet weak var month: UITextField!
	@IBOutlet weak var day: UITextField!
	@IBOutlet weak var year: UITextField!
	
	@IBOutlet weak var dateError: UITextView!
	@IBOutlet weak var formError: UITextView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
		self.view.backgroundColor = UIColor.white
		dateError.isHidden = true
		formError.isHidden = true
    }
	
	
	@IBAction func signUpsubmit(_ sender: UIButton) {
		if !(month.text?.isEmpty)!, !(day.text?.isEmpty)!, !(year.text?.isEmpty)! {
			calculateAge()
		} else {
			dateError.isHidden = dateError.isHidden ? false : true
		}
		
		var errorMessage = ""
		
		if (firstName.text?.isEmpty)! {
			errorMessage += "First name"
		}
		if (lastName.text?.isEmpty)! {
			errorMessage += errorMessage.isEmpty ? "" : ", "
			errorMessage += "Last name"
		}
		if (email.text?.isEmpty)! {
			errorMessage += errorMessage.isEmpty ? "" : ", "
			errorMessage += "Email"
		}
		if (password.text?.isEmpty)! {
			errorMessage += errorMessage.isEmpty ? "" : ", "
			errorMessage += "Password"
		}
		if (confirmPassword.text?.isEmpty)! {
			errorMessage += errorMessage.isEmpty ? "" : ", "
			errorMessage += "Password Confirmation"
		}
		if !errorMessage.isEmpty {
			errorMessage += " required."
			formError!.text = errorMessage
			formError!.isHidden = false
		}
	}
	
	
	@IBAction func backHome(_ sender: UIButton) {
		self.performSegue(withIdentifier: "regToHome", sender: self)
		print()
		let framey = sender.frame.origin
		let f = self.view.convert(framey, to: parent?.view)
		print(f)
		print()
	}
	
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // I did this in such a stupid way I'm sorry
		return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // I did this in such a stupid way I'm sorry
		if section == 0 {
			return 2
		}
		if section == 1 {
			return 4
		}
		if section == 2 {
			return 6
		}
		return 0
    }
	
	func calculateAge() {
		let today = Date()
		let dob_string = month.text! + "/" + day.text! + "/" + year.text!
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MM/dd/yyy"
		let dob = dateFormatter.date(from: dob_string)
		let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
		let calculateAge = calendar.components(.year, from: dob!, to: today, options: [])
		let age = calculateAge.year
		print("Age is \(String(describing: age))")
		print()
		
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

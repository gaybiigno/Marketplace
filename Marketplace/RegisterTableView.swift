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
	@IBOutlet weak var personalError: UITextView!
	@IBOutlet weak var addressError: UITextView!
	
	@IBOutlet weak var addressOne: UITextField!
	@IBOutlet weak var addressTwo: UITextField!
	@IBOutlet weak var city: UITextField!
	@IBOutlet weak var state: UITextField!
	@IBOutlet weak var zipcode: UITextField!
	
	
	private var dateErrorFound = false
	private var personalErrorFound = false
	private var addressErrorFound = false
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
		self.view.backgroundColor = UIColor.white
		dateError.isHidden = true
		personalError.isHidden = true
		addressError.isHidden = true
    }
	
	
	@IBAction func signUpsubmit(_ sender: UIButton) {
		dateErrorFinder()
		personalErrorFinder()
		addressErrorFinder()
	}
	
	
	@IBAction func backHome(_ sender: UIButton) {
		self.performSegue(withIdentifier: "regToHome", sender: self)
	}
	
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
		return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // I did this in such a stupid way lol sorry
		switch section {
		case 0:
			return 1
		case 1:
			return 5
		case 2:
			return 3
		case 3:
			return 6
		default:
			return 0
		}
    }
	
	// Checks if any date sections empty or invalid
	func dateErrorFinder() {
		dateErrorFound = false
		if !(month.text?.isEmpty)!, !(day.text?.isEmpty)!, !(year.text?.isEmpty)! {
			if let uMonth = Int(month.text!), let uDay = Int(day.text!), let uYear = Int(year.text!) {
				if (uMonth < 1 || uMonth > 12) ||
					(uDay < 1 || uDay > 31) ||
					(uYear < 1900 || uYear > 2014){
					dateErrorFound = true
				}
			}
		} else {
			dateErrorFound = true
		}
		if dateErrorFound {
			dateError.isHidden = true
		} else {
			dateError.isHidden = false
			calculateAge()
		}
	}
	
	// Checks if any personal sections empty or invalid
	func personalErrorFinder() {
		personalErrorFound = false
		var errorMessage = ""
		
		if (firstName.text?.isEmpty)! {
			errorMessage += "First name"
			personalErrorFound = true
		}
		if (lastName.text?.isEmpty)! {
			errorMessage += errorMessage.isEmpty ? "" : ", "
			errorMessage += "Last name"
			personalErrorFound = true
		}
		if (email.text?.isEmpty)! {
			errorMessage += errorMessage.isEmpty ? "" : ", "
			errorMessage += "Email"
			personalErrorFound = true
		}
		if (password.text?.isEmpty)! {
			errorMessage += errorMessage.isEmpty ? "" : ", "
			errorMessage += "Password"
			personalErrorFound = true
		}
		if (confirmPassword.text?.isEmpty)! {
			errorMessage += errorMessage.isEmpty ? "" : ", "
			errorMessage += "Password Confirmation"
			personalErrorFound = true
		}
		if personalErrorFound {
			errorMessage += " required."
			personalError.text = errorMessage
			personalError.isHidden = false
		} else {
			personalError.isHidden = true
			// Check if password == confirm password
			if password.text! != confirmPassword.text! {
				personalError.text = "Password Confirmation does not match!"
				personalError.isHidden = false
			}
		}
	}
	
	// Checks if any address sections empty
	func addressErrorFinder() {
		addressErrorFound = false
		var errorMessage = ""
		
		if (addressOne.text?.isEmpty)! {
			errorMessage += "Address Line 1"
			addressErrorFound = true
		}
		if (email.text?.isEmpty)! {
			errorMessage += errorMessage.isEmpty ? "" : ", "
			errorMessage += "City"
			addressErrorFound = true
		}
		if (password.text?.isEmpty)! {
			errorMessage += errorMessage.isEmpty ? "" : ", "
			errorMessage += "State"
			addressErrorFound = true
		}
		if (confirmPassword.text?.isEmpty)! {
			errorMessage += errorMessage.isEmpty ? "" : ", "
			errorMessage += "Zip Code"
			addressErrorFound = true
		}
		if addressErrorFound {
			errorMessage += " required."
			addressError.text = errorMessage
			addressError.isHidden = false
		} else {
			addressError.isHidden = true
		}
		
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

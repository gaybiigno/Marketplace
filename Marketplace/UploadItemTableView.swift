//
//  UploadItemTableView.swift
//  Marketplace
//
//  Created by Gaybriella Igno on 11/24/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class UploadItemTableView: UITableViewController, UITextFieldDelegate, UITextViewDelegate , UIPickerViewDelegate, UIPickerViewDataSource {
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	@IBOutlet weak var titleEntry: UITextField!
	@IBOutlet weak var descriptionEntry: UITextView!
	@IBOutlet weak var descriptionCounter: UILabel!
	@IBOutlet weak var tagEntry: UITextView!
	@IBOutlet weak var priceEntry: UITextField!
	@IBOutlet weak var quantityEntry: UITextField!
	
	@IBOutlet weak var catPicker: UIPickerView!
	@IBOutlet weak var subcatPicker: UIPickerView!
	
	@IBOutlet weak var errorLabel: UILabel!
	@IBOutlet weak var uploadButton: UIButton!
	
	@IBOutlet weak var subCatCell: UITableViewCell!
	
	private var price: String = ""
	private var categories = ["", "Home & Garden", "Fashion", "Electronics", "Art & Collectibles", "Auto & Vehicles", "Sporting Goods"]
	
	private var tags = [String]()
	
	var cv = UploadImageView()
	
	private var categoryChoice = UILabel()
	private var subcategoryChoice = UILabel()
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		descriptionEntry.delegate = self
		priceEntry.delegate = self
		catPicker.delegate = self
		catPicker.dataSource = self
		subcatPicker.delegate = self
		subcatPicker.dataSource = self
		
		start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	func start() {
		uploadButton.isHidden = false
		uploadButton.frame.size = CGSize(width: view.frame.width, height: 40)
		
		errorLabel.isHidden = true
		categoryChoice.text = ""
		descriptionEntry.clearsOnInsertion = true
		
		// Add targets
		uploadButton.addTarget(self, action: #selector(clickUpload(_:)), for: .touchUpInside)
	}
	
	// Description character counter
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		if textView == descriptionEntry {
			descriptionCounter.textColor = UIColor.darkGray
			
			let desc = (self.descriptionEntry.text as NSString).replacingCharacters(in: range, with: text)
			let count = desc.characters.count
			if Int(count) > 1000 {
				descriptionCounter.textColor = UIColor.red
				self.descriptionEntry.text = self.descriptionEntry.text.safelyLimitedTo(length: 1000)
				return false
			}
			descriptionCounter.text = String(count)
			return true
		} else {
			return false
		}
	}

	// Format Price
	@IBAction func changedPrice(_ sender: UITextField) {
		if !(priceEntry.text?.isEmpty)! {
			let entry = self.priceEntry.text as! String
			//print("entry is: \(entry).")
			
			if entry.characters.contains("$"), entry.characters.distance(from: entry.characters.index(of: ".")!, to: entry.characters.endIndex) <= 2
				{
					price.removeLast()
					if price.characters.count == 0 {
						priceEntry.text = ""
						return
					}
			} else {
				if entry != "0" {
					price += entry[entry.count - 1]
				}
			}

			let pcount = price.count
			
			switch pcount {
			case 1:
				priceEntry.text = "$00.0"
				priceEntry.text?.insert(price[0], at: (priceEntry.text?.endIndex)!)
			case 2:
				priceEntry.text = "$00."
				for i in 0 ..< 2 {
					priceEntry.text?.insert(price[i], at: (priceEntry.text?.endIndex)!)
				}
			case 3:
				priceEntry.text = "$0"
				for i in 0 ..< 3 {
					if i == 1 {
						priceEntry.text?.insert(".", at: (priceEntry.text?.endIndex)!)
					}
					priceEntry.text?.insert(price[i], at: (priceEntry.text?.endIndex)!)
				}
			case 4 ..< 8:
				priceEntry.text = "$"
				for i in 0 ..< pcount {
					if i == (pcount - 2) {
						priceEntry.text?.insert(".", at: (priceEntry.text?.endIndex)!)
					}
					priceEntry.text?.insert(price[i], at: (priceEntry.text?.endIndex)!)
				}
//			case 9 ...< 11:
//				priceEntry.textColor = UIColor.red
//				priceEntry.text += "    Max price: "
				
			default:
				priceEntry.text = ""
			}
		}
	}
	
	@IBAction func backButton(_ sender: UIButton) {
		//self.performSegue(withIdentifier: "uploadToHome", sender: self)
		dismiss(animated: true, completion: nil)
	}
	
	@objc func clickUpload(_ sender: UIButton) {
		checkValues()
	}
	
	// Check for entry errors
	private func checkValues() {
		var errorFound = false
		
		// Check if title, price, and category are empty
		if (titleEntry.text?.isEmpty)! {
			errorFound = true
			titleEntry.layer.borderWidth = 1.0
			titleEntry.layer.borderColor = UIColor.red.cgColor
		} else {
			titleEntry.layer.borderWidth = 0
		}
		if (priceEntry.text?.isEmpty)! {
			errorFound = true
			priceEntry.layer.borderWidth = 1.0
			priceEntry.layer.borderColor = UIColor.red.cgColor
		}
		else {
			priceEntry.layer.borderWidth = 0
		}
		if (categoryChoice.text?.isEmpty)! {
			errorFound = true
			catPicker.layer.borderWidth = 1.0
			catPicker.layer.borderColor = UIColor.red.cgColor
		} else {
			catPicker.layer.borderWidth = 0
		}
		
		if cv.displayError() {
			errorFound = true
		}
		
		if errorFound {
			errorLabel.isHidden = false
		}
	}
	
	// Format Category picker
	func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
		
		let titleData = categories[row]
		let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont(name: "Avenir Book", size: 17.0)!,NSAttributedStringKey.foregroundColor:UIColor.black])
		return myTitle
		
	}
	
	
	//MARK: - Delegates and data sources

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return categories.count
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if pickerView == catPicker {
			categoryChoice.text = categories[row]
		}
	}
	
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 11
    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let vc = segue.destination as? HomeView,
			segue.identifier == "uploadToHome" {
			//vc.delegate = self
			vc.signedIn = true
		}
	}
	
	
//	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//		if (segue.identifier == "displayImgUpload") {
//			if segue.destination is UploadImageView {
//				let cv = segue.destination as! UploadImageView
//
//			}
//		}
//	}

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

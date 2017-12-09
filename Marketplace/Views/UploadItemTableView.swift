//
//  UploadItemTableView.swift
//  Marketplace
//
//  Created by Gaybriella Igno on 11/24/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

protocol ImageHandler: class {
    func setImages(_ imageList: UIImage)
}

class UploadItemTableView: UITableViewController, UITextFieldDelegate, UITextViewDelegate , UIPickerViewDelegate, UIPickerViewDataSource, ImageHandler {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
	
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
	@IBOutlet weak var ageEntry: UITextField!
	
	@IBOutlet weak var errorLabel: UILabel!
	@IBOutlet weak var uploadButton: UIButton!
	
	
	private var price: String = ""
	private var finalPrice: Float = 0.0
	private var categories = ["", "Home & Garden", "Fashion", "Electronics", "Art & Collectibles", "Auto & Vehicles", "Sporting Goods"]
	private var tags = [String]()
	
	var categoryChoice = UILabel()
	var cat: String = ""
	var age: Int = 0
	var itemPrice: String = ""
	var itemTitle: String = ""
	var itemDescription: String = ""
	var quantity: Int = 0
	var tagString: String = ""
	
	var editingItem = false
	
    var itemImages = [UIImage]()
	
	private var itemViewer: ItemView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		descriptionEntry.delegate = self
		priceEntry.delegate = self
		catPicker.delegate = self
		catPicker.dataSource = self
		
		if editingItem {
			priceEntry.text = itemPrice
			titleEntry.text = itemTitle
			descriptionEntry.text = itemDescription
			quantityEntry.text = String(quantity)
			tagEntry.text = tagString
			if let index = categories.index(of: cat) {
				catPicker.selectRow(index, inComponent: 0, animated: false)
			}
			categoryChoice.text = cat
		}
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
			default:
				priceEntry.text = ""
			}
		}
	}
	
	@IBAction func backButton(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}
	
	@objc func clickUpload(_ sender: UIButton) {
		let weGood = checkValues()
		if weGood {
			// Save all this shit
			self.performSegue(withIdentifier: "presentUploadedItem", sender: self)
		} else {
			// Basically nothing
		}
		
	}
	
	// Check for entry errors
	private func checkValues() -> Bool {
		var errorFound = false
		
		// Check if title, price, and category are empty
		if (titleEntry.text?.isEmpty)! {
			errorFound = true
			titleEntry.layer.borderWidth = 1.0
			titleEntry.layer.borderColor = UIColor.red.cgColor
            
            print("title error")
		} else {
			titleEntry.layer.borderWidth = 0
		}
		if (priceEntry.text?.isEmpty)! {
			errorFound = true
			priceEntry.layer.borderWidth = 1.0
			priceEntry.layer.borderColor = UIColor.red.cgColor
            
            print("price error")
		}
		else {
			priceEntry.layer.borderWidth = 0
		}
		if (categoryChoice.text?.isEmpty)! {
			errorFound = true
			catPicker.layer.borderWidth = 1.0
			catPicker.layer.borderColor = UIColor.red.cgColor
            print("category error")
		} else {
			catPicker.layer.borderWidth = 0
		}
		
		if itemImages.count == 0 {
			errorFound = true
            print("photo error")
		}
		
		if errorFound {
			errorLabel.isHidden = false
			return false
		}
        
        // IF NO ERROR
        else {
            formatVals()
			return true
        }
	}
	
    
    func formatVals() {
		if !tagEntry.text.isEmpty {
			tags = tagEntry.text.components(separatedBy: " ")
		}
		if let numChars = priceEntry.text?.characters.count {
			let priceToRet = priceEntry.text![1 ..< numChars]
			if let final = Float(priceToRet), numChars > 1 {
				finalPrice = Float(round(100.0 * final)/100.0)
			}
		}
		
		itemPrice = String(finalPrice)
		itemTitle = titleEntry.text!
		itemDescription = descriptionEntry.text
		quantity = (quantityEntry.text?.isEmpty)! ? 1 : Int(quantityEntry.text!)!
		age = (ageEntry.text?.isEmpty)! ? 0 : Int(ageEntry.text!)!
		
		
    }
	
	// Format Category picker
	func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
		
		let titleData = categories[row]
		let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont(name: "Avenir Book", size: 17.0)!,NSAttributedStringKey.foregroundColor:UIColor.black])
		return myTitle
	}
    
    func setImages(_ itemList: UIImage) {
        itemImages.append(itemList)
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
			vc.signedIn = true
		}
        if let vc = segue.destination as? UploadImageView,
            segue.identifier == "displayImgUpload" {
            vc.delegate = self
			if itemImages.count != 0 {
				vc.allImages = itemImages
			}
        }
		if let vc = segue.destination as? ItemView,
			segue.identifier == "presentUploadedItem" {
			vc.editView = true
			vc.imageArray = itemImages
			vc.givenTitle = titleEntry.text!
			vc.descrip = descriptionEntry.text!
			vc.price = finalPrice
			vc.tags = tags
			vc.category = categoryChoice.text!
			vc.quantity = quantity
			vc.age = age
			//vc.imageCounterLabel.text = "1/" + String(itemImages.count)
		}
	}
	
	// Called for editing item
	func setEditValues(Images: [UIImage], Title: String,
	                   Description: String, Price: String,
	                   Quantity: String, Category: String, tags: [String]?) {
		titleEntry.text = Title
		descriptionEntry.text = Description
		priceEntry.text = Price
		quantityEntry.text = Quantity
		categoryChoice.text = Category
		if let index = categories.index(of: Category) {
			catPicker.selectRow(index, inComponent: 0, animated: false)
		}
		if let tag = tags {
			var stringOfTags = ""
			for t in tag {
				stringOfTags += t + " "
			}
			tagEntry.text = stringOfTags
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

//
//  UploadItemTableView.swift
//  Marketplace
//
//  Created by Gaybriella Igno on 11/24/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class UploadItemTableView: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
	
	@IBOutlet weak var titleEntry: UITextField!
	@IBOutlet weak var descriptionEntry: UITextView!
	@IBOutlet weak var descriptionCounter: UILabel!
	@IBOutlet weak var tagEntry: UITextView!
	@IBOutlet weak var priceEntry: UITextField!
	@IBOutlet weak var quantityEntry: UITextField!
	
	@IBOutlet weak var catPicker: UIPickerView!
	@IBOutlet weak var subcatPicker: UIPickerView!
	
	private var price = ""
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		descriptionEntry.delegate = self
		priceEntry.delegate = self
		
		start()
		

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func start() {
		descriptionEntry.clearsOnInsertion = true
	}
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		if textView == descriptionEntry {
			self.descriptionEntry.textColor = UIColor.black
			let desc = (self.descriptionEntry.text as NSString).replacingCharacters(in: range, with: text)
			let count = desc.characters.count
			if Int(count) > 1000 {
			self.descriptionEntry.text = self.descriptionEntry.text.safelyLimitedTo(length: 1000)
				return false
			}
			descriptionCounter.text = String(count)
			return true
		} else {
			return false
		}
	}

	@IBAction func changedPrice(_ sender: UITextField) {
		if !(priceEntry.text?.isEmpty)! {
			let entry = (self.priceEntry.text as! String)
			print("entry is: \(entry).")
			
			if entry.characters.contains("$"), entry.characters.distance(from: entry.characters.index(of: ".")!, to: entry.characters.endIndex) <= 2
				{
					price.removeLast()
					if price.characters.count == 0 {
						priceEntry.text = ""
						return
					}
			} else {
				if price.characters.count != 0, entry != "0" {
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
			case 4 ..< 7:
				priceEntry.text = "$"
				for i in 0 ..< pcount {
					if i == (pcount - 2) {
						priceEntry.text?.insert(".", at: (priceEntry.text?.endIndex)!)
					}
					priceEntry.text?.insert(price[i], at: (priceEntry.text?.endIndex)!)
				}
				
			default:
				print("price is: \(price)")
			}
		}

	}
	
	
//
//	@objc func changePrice(_ sender: UITextField) {
//		let entry = self.priceEntry.text
//		if entry == "" {
//			return
//		}
//		let pcount = entry?.characters.count
//		priceEntry.text = "$00.00"
//		switch pcount {
//		case 1:
//			priceEntry.text?.remove(at: (priceEntry.text?.endIndex)!)
//			priceEntry.text?.insert(entry![0], at: (priceEntry.text?.endIndex)!)
//		case 2:
//			for i in 4 ..< 5 {
//				priceEntry.text?.remove(at: (priceEntry.text?.endIndex)!)
//				priceEntry.text?.insert(entry![i], at: (priceEntry.text?.endIndex)!)
//			}
//		default:
//			print("FELL INTO DEFAULT")
//		}
//	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 8
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

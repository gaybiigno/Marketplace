//
//  MenuTableView.swift
//  Marketplace
//
//  Created by Gaybriella Igno on 11/22/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class MenuTableView: UITableViewController {
	
	
	
	@IBOutlet weak var uploadButton: UIButton!
	@IBOutlet weak var inboxButton: UIButton!
	@IBOutlet weak var profileButton: UIButton!
	
	@IBOutlet weak var unreadIndicator: UIImageView!
	
	fileprivate let unreadImgURL = "https://i.pinimg.com/originals/d0/46/6c/d0466cc72c8f286edb5b0892c191783b.png"
	
	private var unreadMessage = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
		//setButtons()
		self.accessibilityFrame = CGRect(x: 0, y: 0, width: 200, height: 132)
		start()
    }
	
	func start() {
		if unreadMessage {
			unreadIndicator.tag = 69 // lol sorry
			if let url = URL(string: unreadImgURL), let data = try? Data(contentsOf: url),
				let image = UIImage(data: data) {
				unreadIndicator.image = image
			}
		} else {
			if let taggy = unreadIndicator?.tag {
				if taggy == 69 {
					unreadIndicator.tag = 0
					unreadIndicator.removeFromSuperview()
				}
			}
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@objc func clickUpload(_ sender: UIButton) {
		//self.performSegue(withIdentifier: "homeToReg", sender: self)
		print()
	}
	
	@objc func clickInbox(_ sender: UIButton) {
		//self.performSegue(withIdentifier: "homeToReg", sender: self)
		print()
	}
	
	@objc func clickProfile(_ sender: UIButton) {
		//self.performSegue(withIdentifier: "homeToReg", sender: self)
		print()
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

/*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

			let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
		
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
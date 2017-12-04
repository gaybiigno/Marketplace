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
	@IBOutlet weak var signOutButton: UIButton!
	
	@IBOutlet weak var unreadIndicator: UIImageView!
	
	weak var delegate: SegueHandler?
	
	private var unreadMessage = true

    override func viewDidLoad() {
        super.viewDidLoad()
		start()
    }
	
	func start() {
		uploadButton.addTarget(self, action: #selector(clickUpload(_:)), for: .touchUpInside)
		inboxButton.addTarget(self, action: #selector(clickInbox(_:)), for: .touchUpInside)
		profileButton.addTarget(self, action: #selector(clickProfile(_:)), for: .touchUpInside)
		signOutButton.addTarget(self, action: #selector(clickSignOut(_:)), for: .touchUpInside)
		
        unreadIndicator.isHidden = !unreadMessage
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	@objc func clickUpload(_ sender: UIButton) {
		delegate?.segueToNext(identifier: "homeToUp")
	}
	
	@objc func clickSignOut(_ sender: UIButton) {
		delegate?.signOut()
	}
	
	
	@objc func clickInbox(_ sender: UIButton) {
		//self.performSegue(withIdentifier: "homeToReg", sender: self)
		print("no inbox yet")
	}
	
	@objc func clickProfile(_ sender: UIButton) {
		//self.performSegue(withIdentifier: "homeToReg", sender: self)
		print("no prof yet")
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
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

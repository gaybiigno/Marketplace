//
//  InboxTableView.swift
//  Marketplace
//
//  Created by Gaybriella Igno on 12/7/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class InboxTableView: UITableViewController {
	
	private let dummyImg = UIImage(named: "PhotoIcon")
	private let dummySubjects = ["Blue Patagonia Half-Zip", "2007 Silver Volvo XC90", "Homemade pants", "Brand New XBox 360!!!!"]
	private let dummyPeople = ["DeAndre H.", "Josh G.", "Antonio B.", "Tom B."]
	private let dummyRead = [true, false]
    
    
    var downloadAssistant = Download(withURLString: "http://localhost:8181/inbox/all")
    
    var thisUser: User!
    var inboxSchema: InboxSchemaProcessor!
    var inboxDataSource: InboxDataSource!
    
    var inboxItems: [Inbox]!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.view.backgroundColor = UIColor(red: 1.0, green: 0.3254, blue: 0.2392, alpha: 1.0)
		self.tableView.rowHeight = 75.0
		
        
        downloadAssistant.addObserver(self, forKeyPath: "dataFromServer", options: .old, context: nil)
        downloadAssistant.download_request()
        
        if let t = thisUser {
            inboxItems = inboxSchema.fetchForRecipient(t.email!)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //        print(downloadAssistant.dataFromServer!)
            
        inboxSchema = InboxSchemaProcessor(inboxModelJSON: downloadAssistant.dataFromServer! as! [AnyObject])
        print("---------msgs downloaded-----------")
        let inbox_returned = inboxSchema.getAllInboxs()
        
        inboxDataSource = InboxDataSource(dataSource: inbox_returned)
        inboxDataSource?.consolidate()
    }
    
    deinit {
        if downloadAssistant != nil {
            downloadAssistant.removeObserver(self, forKeyPath: "dataFromServer", context: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let messages = inboxItems {
            return messages.count
        }
		return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "msgCell", for: indexPath)
		cell.selectionStyle = .none
		if let msgCell = cell as? InboxMsgTableCell {
            let sub = inboxItems[indexPath.row].subject
            let tUser = inboxItems[indexPath.row].recipient_email
            let otherUser = inboxItems[indexPath.row].sender_email
            let content = inboxItems[indexPath.row].message
            msgCell.useMessage(sub!, tUser!, otherUser!, content!, true)
		}
		

        // Configure the cell...

        return cell
    }
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		print("tapped")
	}


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

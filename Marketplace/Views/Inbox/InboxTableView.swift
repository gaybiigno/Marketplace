//
//  InboxTableView.swift
//  Marketplace
//
//  Created by Gaybriella Igno on 12/7/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class InboxTableView: UITableViewController {

    var thisUserEmail: String!
    var thisUserFName: String!
    var thisUserLName: String!
    var otherUserFName: String!
    var otherUserLName: String!
    var inboxSchema: InboxSchemaProcessor!
    var inboxDataSource: InboxDataSource!
    
    var inboxItems: [Inbox]!
	var downloadAssistant = Download(withURLString: "http://localhost:8181/inbox/all") //?apikey=" + Download.apikey)
    var udownloadAssistant: Download!
    var odownloadAssistant: Download!
    
    var inboxUp = false
    var userThis = false
    var userOther = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inboxUp = true
        downloadAssistant.addObserver(self, forKeyPath: "dataFromServer", options: .old, context: nil)
        downloadAssistant.download_request()
		
        if let email = thisUserEmail {
            print("got email")
            inboxUp = false
            userThis = true
            udownloadAssistant = Download(withURLString: buildURLString(email))
            udownloadAssistant.addObserver(self, forKeyPath: "dataFromServer", options: .old, context: nil)
            udownloadAssistant.download_request()
        } else {
            print("didn't get email")
        }
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: Int(self.tableView.frame.width), height: 50))
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 30))
        //let titleText = NSAttributedString(string: "Inbox", attributes: [NSAttributedStringKey.font:UIFont(name: "Avenir Book", size: 22.0)!,NSAttributedStringKey.foregroundColor:UIColor.black])
        titleLabel.text = "Inbox" //titleText.string //as! String
        //titleLabel.attributedText = titleText
        titleLabel.textAlignment = .center
        titleLabel.center = header.center
        header.addSubview(titleLabel)
        
        let back = UIButton(frame: CGRect(x: 8, y: 10, width: 30, height: 30))
        back.titleLabel?.text = ""
        back.setImage(UIImage(named: "BackIcon"), for: .normal)
        back.frame = CGRect(x: 8, y: 10, width: 30, height: 30)
        back.addTarget(self, action: #selector(clickedBack(_:)), for: .touchUpInside)
        back.isHidden = false
        header.addSubview(back)
        
        self.tableView.tableHeaderView = header
        
    }
    
    func buildURLString(_ anEmail: String) -> String {
        var url = Download.baseURL
        url += "/users/"
        url += "?email=" + anEmail
        url += "&apikey=" + Download.apikey
        return url
    }
    
    @objc func clickedBack(_ sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Functions for Download
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if userThis {
            let userSchema = UserSchemaProcessor(userModelJSON: udownloadAssistant.dataFromServer! as! [AnyObject])
            let userDataSource = UserDataSource(dataSource: userSchema.getAllUsers())
            userDataSource.consolidate()
            let thisUser = userDataSource.userAt(0)
            thisUserFName = thisUser?.first_name
            thisUserLName = thisUser?.last_name
            //self.tableView.reloadData()
        }
        else if userOther {
            let userSchema = UserSchemaProcessor(userModelJSON: odownloadAssistant.dataFromServer! as! [AnyObject])
            let userDataSource = UserDataSource(dataSource: userSchema.getAllUsers())
            userDataSource.consolidate()
            let otherUser = userDataSource.userAt(0)
            otherUserFName = otherUser?.first_name
            otherUserLName = otherUser?.last_name
            //self.tableView.reloadData()
        }
        else if inboxUp {
            inboxSchema = InboxSchemaProcessor(inboxModelJSON: downloadAssistant.dataFromServer! as! [AnyObject])
            let inbox_returned = inboxSchema.getAllInboxs()
            
            inboxDataSource = InboxDataSource(dataSource: inbox_returned)
            inboxDataSource?.consolidate()
            
            if let t = thisUserEmail {
                inboxItems = inboxSchema.fetchForRecipient(t)
                self.tableView.reloadData()
            }
        }
    }
    
    deinit {
        downloadAssistant.removeObserver(self, forKeyPath: "dataFromServer", context: nil)
        if udownloadAssistant != nil {
            udownloadAssistant.removeObserver(self, forKeyPath: "dataFromServer", context: nil)
        }
        if odownloadAssistant != nil {
            odownloadAssistant.removeObserver(self, forKeyPath: "dataFromServer", context: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            cell.selectionStyle = .blue
            if let msgCell = cell as? InboxMsgTableCell {
                let sub = inboxItems[indexPath.row].subject
                var tUser = inboxItems[indexPath.row].recipient_email
                
                if let f = thisUserFName, let l = thisUserLName {
                    tUser = f + " " + l[0] + "."
                }
                if let oEmail = inboxItems[indexPath.row].sender_email {
                    odownloadAssistant = Download(withURLString: buildURLString(oEmail))
                    userThis = false
                    inboxUp = false
                    userOther = true
                    odownloadAssistant.addObserver(self, forKeyPath: "dataFromServer", options: .old, context: nil)
                    odownloadAssistant.download_request()
                }
                var otUser = inboxItems[indexPath.row].sender_email
                if let f = otherUserFName, let l = otherUserLName {
                    otUser = f + " " + l[0] + "."
                }
                
                let content = inboxItems[indexPath.row].message
                msgCell.useMessage(sub!, tUser!, otUser!, content!, true)
            }
            return cell
    }
    
    
	
	// MARK: - Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let vc = segue.destination as? InboxDetailView,
            segue.identifier == "showMsgDetail" { //"cellToDetail" {
            print(inboxItems)
			if let cell = sender as? InboxMsgTableCell, let indexPath = tableView.indexPath(for: cell)  {
                let idx = indexPath.row
				let sub = inboxItems[idx].subject
				let tUser = inboxItems[idx].recipient_email
				let otherUserEmail = inboxItems[idx].sender_email
                let uName = thisUserFName! + " " + thisUserLName![0] + "."
                let oName = otherUserFName! + " " + otherUserLName![0] + "."
				let content = inboxItems[idx].message
                vc.showMessage(sub!, tUser!, otherUserEmail!, content!, uName, oName)
			}
		}
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


}




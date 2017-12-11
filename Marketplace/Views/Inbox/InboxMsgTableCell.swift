//
//  InboxMsgTableCell.swift
//  Marketplace
//
//  Created by Gaybriella Igno on 12/7/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class InboxMsgTableCell: UITableViewCell {


    @IBOutlet weak var msgSubject: UILabel!
    @IBOutlet weak var otherUserName: UILabel!
	
	 //var thisMessage: Message? = nil
	var originalCenter = CGPoint()
	var deleteOnDragRelease = false
	var originalFrame = CGRect()
    
    var subject: String!
    var content: String!
    var thisUserName: String!
    var otherName: String!
	
	override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
	
    func useMessage(_ subject: String, _ thisUser: String, _ otherUser: String, _ msgContent: String, _ iconShown: Bool) {
		//itemImage.image = img
		self.subject = subject
		self.otherName = otherUser
        self.content = msgContent
        self.thisUserName = thisUser
        
        msgSubject.text = subject
        otherUserName.text = otherName
	}
	
	/*
	func useMessage(_ message: Message?) {
		thisMessage = message
		if let m = message {
			msgSubject.text = message?.subject
			cellPrice.text = String (describing: message?.price)
		} else {
			cellLabel.text = "Item not found!"
		}
	}
*/

}

//
//  InboxDetailView.swift
//  Marketplace
//
//  Created by Gaybriella Igno on 12/10/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class InboxDetailView: UIViewController {
	
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var msgSubject: UILabel!
	@IBOutlet weak var senderLabel: UILabel!
	@IBOutlet weak var recipientLabel: UILabel!
	@IBOutlet weak var msgContent: UITextView!
	@IBOutlet weak var replyButton: UIButton!
	
	//var downloadAssistant: Download!
	
	var subject: String!
	var senderEmail: String!
	var recipientEmail: String!
	var content: String!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		backButton.addTarget(self, action: #selector(clickedBack(_:)), for: .touchUpInside)
		replyButton.addTarget(self, action: #selector(clickedReply(_:)), for: .touchUpInside)
		
		if let s = self.subject {
			msgSubject.text = s
		} else {
			msgSubject.text = "Message"
		}
		if let se = self.senderEmail {
			senderLabel.text = se
		}
		if let c = self.content {
			msgContent.text = c
		}
		if let re = self.recipientEmail {
			recipientLabel.text = re
		}
		
	}
	
	func showMessage(_ subject: String, _ thisUser: String, _ otherUser: String, _ msgContent: String) {
		self.subject = subject
		self.senderEmail = otherUser
		self.content = msgContent
		self.recipientEmail = thisUser
	}
	
	
	@objc func clickedBack(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}
	
	@objc func clickedReply(_ sender: UIButton) {
		self.performSegue(withIdentifier: "replyMessage", sender: self)
	}
	
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MARK: - Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let vc = segue.destination as? SendMessageView,
			segue.identifier == "replyMessage" {
			vc.setDefaultValues(self.recipientEmail, self.senderEmail, self.subject)
			
		}
		
	}
	
}


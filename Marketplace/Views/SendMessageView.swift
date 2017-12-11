//
//  SendMessageView.swift
//  Marketplace
//
//  Created by Gaybriella Igno on 12/4/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class SendMessageView: UIViewController {
	
	@IBOutlet weak var senderLabel: UILabel!
	@IBOutlet weak var recipientLabel: UILabel!
	
	@IBOutlet weak var subjectLabel: UILabel!
	@IBOutlet weak var messageBody: UITextView!

	@IBOutlet weak var successMessage: UILabel!
	@IBOutlet weak var sendMsgTitle: UILabel!
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var sendButton: UIButton!
	
	var reply = false
	var sender: String!
	var recipient: String!
	var subject: String!
	var msgBody: String!
    
    var buyerEmail: String!
    var sellerEmail: String!
	
	var uploadAssistant: Upload! = nil
    
    
	
	override func viewDidLoad() {
        super.viewDidLoad()

        print(buyerEmail)
        print(sellerEmail)
		start()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func start() {
		// Send button spans window, send target
		sendButton.frame.size = CGSize(width: view.frame.width, height: 50)
		sendButton.addTarget(self, action: #selector(clickedSend(_:)), for: .touchUpInside)
		
		// Set editable text border
		messageBody.layer.borderColor = UIColor.black.cgColor
		messageBody.layer.borderWidth = 0.5
		
		// Set labels
		setSender()
		setRecipient()
		setSubject()
		
		// Set tags for successful send
		sendButton.tag = 50
		sendMsgTitle.tag = 50
		backButton.tag = 50
		successMessage.tag = 50
		successMessage.frame.size = CGSize(width: view.frame.width, height: 50)
	}
	/*
	func buildUploadURL() -> String {
		var url = Upload.baseURL + "/inbox/insert"
		url += "?recipient_email=" + recipient
		url += "&sender_email=" + sender
		url += "&message=" + msgBody
		url += "&subject=" + subject
		return url
	}
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		print("uploaded new item")
	}
	*/
	func setSender() {
		senderLabel.text = sender
	}
	
	func setRecipient() {
		recipientLabel.text = recipient
	}
	
	func setSubject() {
		subjectLabel.text = subject
	}
    
	@IBAction func clickedBack(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}
	
	func setDefaultValues(_ sender: String, _ rec: String, _ item: String) {
		self.sender = sender
		self.recipient = rec
		self.subject = item
	}
	
	@objc func clickedSend(_ sender: UIButton) {
		if let msg = messageBody.text {
			msgBody = msg
		} else {
			return
		}
		if successMessage.isHidden {
			successMessage.isHidden = false
			
			// SAVE MESSAGE VALUES
			
			for v in view.subviews {
				if v.tag != 50 {
					v.removeFromSuperview()
				}
			}
			
			sendButton.setTitle("Go To Messages", for: .normal)
			let buttonFrame = sendButton.frame
			sendButton.frame = CGRect(x: buttonFrame.minX, y: successMessage.frame.maxY + 20.0, width: view.frame.width, height: 50.0)
		} else {
//			uploadAssistant = Upload(withURLString: buildUploadURL())
//			uploadAssistant.addObserver(self, forKeyPath: "dataFromServer", options: .old, context: nil)
//			uploadAssistant.upload_request()
			self.performSegue(withIdentifier: "sendMsgToInbox", sender: self)
			// Make it go to inbox
		}
	}
	
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let vc = segue.destination as? InboxTableView,
			segue.identifier == "sendMsgToInbox" {
			vc.thisUserEmail = self.sender
			print(sender!, recipient!, subject!, msgBody!)
		}
    }
	

}

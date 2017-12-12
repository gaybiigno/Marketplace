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
	var sender: String! // buyer
	var recipient: String!
	var subject: String!
	var msgBody: String!
    
    var buyerEmail: String!
    var sellerEmail: String!
    
    var userSchema: UserSchemaProcessor!
    var userDataSource: UserDataSource!

    var senderB = false
    var recipientB = false
    var downloadAssistant: Download!
    var rdownloadAssistant: Download!
	var uploadAssistant: Upload! = nil
    
	override func viewDidLoad() {
        super.viewDidLoad()

        if sender == nil || recipient == nil {
            senderB = true
            downloadAssistant = Download(withURLString: buildURLString(buyerEmail))
            downloadAssistant.addObserver(self, forKeyPath: "dataFromServer", options: .old, context: nil)
            downloadAssistant.download_request()
            senderB = false
            recipientB = true
            downloadAssistant = Download(withURLString: buildURLString(sellerEmail))
            downloadAssistant.addObserver(self, forKeyPath: "dataFromServer", options: .old, context: nil)
            downloadAssistant.download_request()
        }
        
		start()
    }
    
    func buildURLString(_ anEmail: String) -> String {
        var url = Download.baseURL
        url += "/users/"
        url += "?email=" + anEmail
        url += "&apikey=" + Download.apikey
        return url
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
	
	func buildUploadURL() -> String {
		var url = Upload.baseURL + "/inbox/insert"
		url += "?recipient_email=" + sellerEmail
		url += "&sender_email=" + buyerEmail
		url += "&message=" + msgBody.replacingOccurrences(of: " ", with: "_")
		url += "&subject=" + subject.replacingOccurrences(of: " ", with: "_")
		return url
	}
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if senderB {
            userSchema = UserSchemaProcessor(userModelJSON: downloadAssistant.dataFromServer! as! [AnyObject])
            userDataSource = UserDataSource(dataSource: userSchema.getAllUsers())
            userDataSource.consolidate()
            let currentUser = userDataSource.userAt(0)!
            sender = currentUser.first_name! + " " + currentUser.last_name![0] + "."
        }
        else if recipientB {
            userSchema = UserSchemaProcessor(userModelJSON: downloadAssistant.dataFromServer! as! [AnyObject])
            userDataSource = UserDataSource(dataSource: userSchema.getAllUsers())
            userDataSource.consolidate()
            let currentUser = userDataSource.userAt(0)!
            recipient = currentUser.first_name! + " " + currentUser.last_name![0] + "."
        }
		print("uploaded new inboxy")
	}
    
    deinit {
        if downloadAssistant != nil {
            downloadAssistant.removeObserver(self, forKeyPath: "dataFromServer", context: nil)
        }
        if uploadAssistant != nil {
            uploadAssistant.removeObserver(self, forKeyPath: "dataFromServer", context: nil)
        }
    }

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
	
    func setDefaultValues(_ sender: String!, _ rec: String!, _ item: String, _ se: String, _ re: String) {
		self.sender = sender
		self.recipient = rec
		self.subject = item
        self.buyerEmail = se
        self.sellerEmail = re
	}
	
	@objc func clickedSend(_ sender: UIButton) {
		if successMessage.isHidden {
            if let msg = messageBody.text {
                msgBody = msg
            } else {
                return
            }
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
            uploadAssistant = Upload(withURLString: buildUploadURL())
            uploadAssistant.addObserver(self, forKeyPath: "dataFromServer", options: .old, context: nil)
            uploadAssistant.upload_request()
			self.performSegue(withIdentifier: "sendMsgToInbox", sender: self)
			// Make it go to inbox
		}
	}
	
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let vc = segue.destination as? InboxTableView,
			segue.identifier == "sendMsgToInbox" {
			vc.thisUserEmail = self.buyerEmail
			print(sender!, recipient!, subject!, msgBody!)
		}
    }
	

}

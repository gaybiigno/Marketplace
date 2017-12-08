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
	
	var sender = ""
	var recipient = ""
	var subject = ""
	
	override func viewDidLoad() {
        super.viewDidLoad()

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
		sendMsgTitle.tag = 50
		backButton.tag = 50
		successMessage.tag = 50
		successMessage.frame.size = CGSize(width: view.frame.width, height: 50)
		
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
	
	func setDefaultValues(_ rec: String, item: String, vc: ItemView) {
		recipient = rec
		subject = item
	}
	
	@objc func clickedSend(_ sender: UIButton) {
		if successMessage.isHidden {
			let msgBody = messageBody.text
			
			// SAVE MESSAGE VALUES
			
			for v in view.subviews {
				if v.tag != 50 {
					v.removeFromSuperview()
				}
			}
			
			successMessage.isHidden = false
			sendButton.setTitle("Go To Messages", for: .normal)
			let buttonFrame = sendButton.frame
			sendButton.frame = CGRect(x: buttonFrame.minX, y: successMessage.frame.maxY + 20.0, width: view.frame.width, height: 50.0)
		} else {
			// Make it go to inbox
		}
		
	}
	
	
//	let homeButton = UIButton(frame: CGRect(x: sendButton.frame.minX, y: sendButton.frame.maxY + 10.0, width: view.frame.width, height: sendButton.frame.height))
//	homeButton.addTarget(self, action: #selector(clickedHome(_:)), for: .touchUpInside)

	
	
	
	
	
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

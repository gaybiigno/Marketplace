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
		// Send button spans window
		sendButton.frame.size = CGSize(width: view.frame.width, height: 50)
		
		// Set editable text border
		messageBody.layer.borderColor = UIColor.black.cgColor
		messageBody.layer.borderWidth = 0.5
		
		// Set labels
		setSender()
		setRecipient()
		setSubject()
		
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
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

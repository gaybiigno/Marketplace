//
//  ForgotPasswordView.swift
//  Marketplace
//
//  Created by Gaybriella Igno on 11/22/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit
import MessageUI

class ForgotPasswordView: UIViewController, MFMailComposeViewControllerDelegate {

	
	@IBOutlet weak var titleLabel: UITextField!
	@IBOutlet weak var firstPrompt: UITextView!
	@IBOutlet weak var completePrompt: UITextView!
	@IBOutlet weak var email: UITextField!
	@IBOutlet weak var enterButton: UIButton!
	
	fileprivate var complete = false
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		enterButton.frame.size = CGSize(width: view.frame.width, height: 45)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func clickedBack(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}
	
	
	@IBAction func pressedEnter(_ sender: UIButton) {
		if !complete {
			// TODO:: If email is not valid or empty
			if (email.text?.isEmpty)! {
				firstPrompt.text = "Please enter a valid email address. For example: jdoe@domain.com"
				email.layer.borderColor = UIColor.red.cgColor
				email.layer.borderWidth = 1.5
				email.text = ""
			} else {
				complete = true
				firstPrompt.isHidden = true
				let savedEmail = email.text
				email.isHidden = true
				self.completePrompt.text = completePrompt.text + savedEmail! + " you will receive an email with a link to reset your password."
				completePrompt.isHidden = false
				enterButton.setTitle("Back To Home", for: .normal)
				sendEmail(recipient: savedEmail!)
			}
		} else {
			self.performSegue(withIdentifier: "forgotToHome", sender: self)
		}
	}
	
	func sendEmail(recipient: String) {
		if MFMailComposeViewController.canSendMail() {
			let tempPass = randomStringWithLength(len: 6)
			
			let mail = MFMailComposeViewController()
			mail.mailComposeDelegate = self
			mail.setToRecipients([recipient])
			mail.setSubject("Password reset")
			
			let emailBody = "<p>Hi there, <br/> You are recieving this email because you requested a password reset" +
			" in our Marketplace app! Consider your password officially reset. Follow these steps to sign in:<br/>" +
			"  1. Open the Marketplace App<br/>  2. Click 'Sign In'<br/>  3. Use your email and the temporary password: '" +
				(tempPass as String) +
			"'<br/>  4. Log in and set your new password!<br/><br/>Thanks for choosing us and don't forget to rate in the app store,<br/>The MArketplace Squad</p>"
			
			mail.setMessageBody(emailBody, isHTML: true)
			present(mail, animated: true)
		} else {
			print("Failure to launch - mail")
		}
	}
	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		controller.dismiss(animated: true)
	}
	
	func randomStringWithLength (len : Int) -> NSString {
		
		let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		
		let randomString : NSMutableString = NSMutableString(capacity: len)
		
		for _ in 0 ..< len {
			let length = UInt32 (letters.length)
			let rand = arc4random_uniform(length)
			randomString.appendFormat("%C", letters.character(at: Int(rand)))
		}
		
		return randomString
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

//
//  ForgotPasswordView.swift
//  Marketplace
//
//  Created by Gaybriella Igno on 11/22/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class ForgotPasswordView: UIViewController {

	
	@IBOutlet weak var firstPrompt: UITextView!
	@IBOutlet weak var completePrompt: UITextView!
	@IBOutlet weak var email: UITextField!
	@IBOutlet weak var enterButton: UIButton!
	
	fileprivate var complete = false
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
			}
		} else {
			self.performSegue(withIdentifier: "forgotToHome", sender: self)
		}
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

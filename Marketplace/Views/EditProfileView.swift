//
//  EditProfileView.swift
//  Marketplace
//
//  Created by Gaybriella Igno on 12/6/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit
import Photos

class EditProfileView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	@IBOutlet weak var profilePicture: UIImageView!
	@IBOutlet weak var newPictureButton: UIButton!
	@IBOutlet weak var deletePictureButton: UIButton!
	
	@IBOutlet weak var firstNameEntry: UITextField!
	@IBOutlet weak var lastNameEntry: UITextField!
	@IBOutlet weak var addrLine1: UITextField!
	@IBOutlet weak var addrLine2: UITextField!
	@IBOutlet weak var cityEntry: UITextField!
	@IBOutlet weak var stateEntry: UITextField!
	@IBOutlet weak var zipEntry: UITextField!
	
	@IBOutlet weak var errorLabel: UILabel!
	
	let imagePicker = UIImagePickerController()
	let defaultProfilePic = UIImage(named: "DefaultProfileIcon")
	
	var firstName: String!
	var lastName: String!
	var addLine1 = ""
	var addLine2 = ""
	var city = ""
	var state = ""
	var zip: Int = 0
	var profPicture: UIImage!
	
	var errorMessage = ""
	var hasVal = false
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		imagePicker.delegate = self
		
		self.view.backgroundColor = UIColor.white
		profilePicture.layer.borderWidth = 0.6
		profilePicture.layer.borderColor = UIColor.black.cgColor
		
		start()
		
		if self.hasVal {
			setOldValues()
		}
    }
	
	func start() {
		// Add targets
		newPictureButton.addTarget(self, action: #selector(clickedNew(_:)), for: .touchUpInside)
		deletePictureButton.addTarget(self, action: #selector(clickedDelete(_:)), for: .touchUpInside)
		
		if profPicture == nil {
			profilePicture.image = defaultProfilePic
			deletePictureButton.layer.opacity = 0.6
		}
		
	}
	
	func setOldValues() {
		if let fName = firstName {
			firstNameEntry.text = fName
		}
		if let lName  = lastName {
			lastNameEntry.text = lName
		}
	}
	
	@objc func clickedNew(_ selector: UIButton) {
		checkPermission()
	}
	
	@objc func clickedDelete(_ selector: UIButton) {
		if profPicture == defaultProfilePic {
			return
		}
		profPicture = defaultProfilePic
		profilePicture.image = profPicture
		deletePictureButton.layer.opacity = 0.6
	}
	
	@IBAction func clickedSubmit(_ sender: UIButton) {
		let errorFound = checkValues()
		if errorFound {
			errorLabel.text = errorMessage
		} else {
			firstName = firstNameEntry.text!
			lastName = lastNameEntry.text!
			addLine1 = addrLine1.text!
			addLine2 = addrLine2.text!
			city = cityEntry.text!
			state = (stateEntry.text?.uppercased())!
			zip = Int(zipEntry.text!)!
			errorLabel.text = "Success! Changes Saved."
		}
	}
	
	func checkValues() -> Bool {
		errorMessage = ""
		// Check if name is empty
		if (firstNameEntry.text?.isEmpty)! || (lastNameEntry.text?.isEmpty)! {
			errorMessage = "First and Last Name required."
		}
		
		// Check if address is empty
		if (addrLine1.text?.isEmpty)! || (cityEntry.text?.isEmpty)! || (stateEntry.text?.isEmpty)! || (zipEntry.text?.isEmpty)! {
			errorMessage = "Address Line 1, City, State, and Zip required."
		}
		
		return !errorMessage.isEmpty
	}
	
	
	
	@IBAction func clickedChangePass(_ sender: UIButton) {
		print("Clicked changed Password!")
	}
	
	@IBAction func clickedDeleteAcct(_ sender: UIButton) {
		print("Clicked delete account!")
	}
	
	@IBAction func clickedBack(_ sender: UIButton) {
		if let presenter = presentingViewController as! HomeView? {
			if !firstName.isEmpty && !lastName.isEmpty {
				let name = firstName + " " + String(lastName[0]) + "."
				presenter.uName = name
				presenter.updateUserName(name)
			}
		}
		dismiss(animated: true, completion: nil)
	}
	
	func checkPermission() {
		let photoAuthStatus = PHPhotoLibrary.authorizationStatus()
		switch photoAuthStatus {
		case .authorized:
			imagePicker.allowsEditing = false
			imagePicker.sourceType = .photoLibrary
			present(imagePicker, animated: true, completion: nil)
			print("Access granted")
		case .notDetermined:
			PHPhotoLibrary.requestAuthorization({
				(newStatus) in
				print("status is \(newStatus)")
				if newStatus ==  PHAuthorizationStatus.authorized {
					self.imagePicker.allowsEditing = false
					self.imagePicker.sourceType = .photoLibrary
					self.present(self.imagePicker, animated: true, completion: nil)
					print("success")
				}
			})
			print("It is not determined until now")
		case .restricted:
			print("User does not have access")
		case .denied:
			print("Denied")
		}
	}
	
	@objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
			profPicture = pickedImage
			profilePicture.image = profPicture // pickedImage
			profilePicture.contentMode = .scaleToFill
			deletePictureButton.layer.opacity = 1.0
		}
		imagePicker.dismiss(animated: true, completion: nil)
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		imagePicker.dismiss(animated: true, completion: nil)
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

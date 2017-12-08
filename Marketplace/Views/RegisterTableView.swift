//
//  RegisterTableView.swift
//  Marketplace
//
//  Created by Gaybriella Igno on 11/9/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit
import Photos

class RegisterTableView: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var addPicButton: UIButton!
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBOutlet weak var month: UITextField!
    @IBOutlet weak var day: UITextField!
    @IBOutlet weak var year: UITextField!
    
    @IBOutlet weak var dateError: UITextView!
    @IBOutlet weak var personalError: UITextView!
    @IBOutlet weak var addressError: UITextView!
    
    @IBOutlet weak var addressOne: UITextField!
    @IBOutlet weak var addressTwo: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zipcode: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    
    private var dateErrorFound = false
    private var personalErrorFound = false
    private var addressErrorFound = false
    
    private var username: String = ""
    
    let uploadAssistant: Upload! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        //uploadAssistant.addObserver(self, forKeyPath: "dataToServer", options: .old, context: nil)
        
        signUpButton.frame.size = CGSize(width: view.frame.width, height: 45)

        self.view.backgroundColor = UIColor.white
        dateError.isHidden = true
        personalError.isHidden = true
        addressError.isHidden = true
        
        addPicButton.imageView?.contentMode = .scaleToFill
        addPicButton.addTarget(self, action: #selector(clickNew(_:)), for: .touchUpInside)
    }
    
    @objc func clickNew(_ sender: UIButton){
        checkPermission()
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
            profilePicture.image = pickedImage
            profilePicture.contentMode = .scaleToFill
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func signUpsubmit(_ sender: UIButton) {
        dateErrorFinder()
        if !(personalErrorFinder() || addressErrorFinder()) {
            // Set default profile picture
            if profilePicture.image == nil {
                profilePicture.image = UIImage(named: "DefaultProfileIcon")
            }
            let queryURL = buildSubmissionURL()
            let uploadAssistant = Upload(withURLString: queryURL)
            uploadAssistant.addObserver(self, forKeyPath: "dataToServer", options: .old, context: nil)
            uploadAssistant.upload_request()
            
            self.performSegue(withIdentifier: "completeRegToHome", sender: self)
            
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("items uploaded")
    }
    
    deinit {
        uploadAssistant.removeObserver(self, forKeyPath: "dataFromServer", context: nil)
    }
    
    func buildSubmissionURL() -> String {
        var url = Upload.baseURL + "/users/insert?"
        url = url + "email=" + email.text!
        url = url + "&pass=" + password.text!
        url = url + "&first_name=" + firstName.text!
        url = url + "&last_name=" + lastName.text!
        url = url + "&payment=" + "none"
        url = url + "&picture=" + "none"
        url = url + "&street=" + addressOne.text!.replacingOccurrences(of: " ", with: "_") +
            addressTwo.text!.replacingOccurrences(of: " ", with: "_")
        url = url + "&city=" + city.text!
        url = url + "&zip=" + zipcode.text!
        url = url + "&_state=" + state.text!
        url = url + "&day=" + day.text!
        url = url + "&month=" + month.text!
        url = url + "&year=" + year.text!
        url = url + "&apikey=" + Upload.apikey
        return url
    }
    
    
    @IBAction func backHome(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // I did this in such a stupid way lol sorry
        switch section {
        case 0:
            return 2
        case 1:
            return 5
        case 2:
            return 3
        case 3:
            return 6
        default:
            return 0
        }
    }
    
    // Checks if any date sections empty or invalid
    func dateErrorFinder() {
        dateErrorFound = false
        if !(month.text?.isEmpty)!, !(day.text?.isEmpty)!, !(year.text?.isEmpty)! {
            if let uMonth = Int(month.text!), let uDay = Int(day.text!), let uYear = Int(year.text!) {
                if (uMonth < 1 || uMonth > 12) ||
                    (uDay < 1 || uDay > 31) ||
                    (uYear < 1900 || uYear > 2014){
                    dateErrorFound = true
                }
            }
        } else {
            dateErrorFound = true
        }
        if dateErrorFound {
            dateError.isHidden = false
        } else {
            dateError.isHidden = true
            calculateAge()
        }
    }
    
    // Checks if any personal sections empty or invalid
    func personalErrorFinder() -> Bool {
        personalErrorFound = false
        var errorMessage = ""
        
        if (firstName.text?.isEmpty)! {
            errorMessage += "First name"
            personalErrorFound = true
        }
        if (lastName.text?.isEmpty)! {
            errorMessage += errorMessage.isEmpty ? "" : ", "
            errorMessage += "Last name"
            personalErrorFound = true
        }
        if (email.text?.isEmpty)! {
            errorMessage += errorMessage.isEmpty ? "" : ", "
            errorMessage += "Email"
            personalErrorFound = true
        } else {
            if !(email.text?.contains("@"))! {
                personalErrorFound = true
                print("uh oh no @")
            }
        }
        if (password.text?.isEmpty)! {
            errorMessage += errorMessage.isEmpty ? "" : ", "
            errorMessage += "Password"
            personalErrorFound = true
        }
        if (confirmPassword.text?.isEmpty)! {
            errorMessage += errorMessage.isEmpty ? "" : ", "
            errorMessage += "Password Confirmation"
            personalErrorFound = true
        }
        if personalErrorFound {
            errorMessage += " required."
            personalError.text = errorMessage
            personalError.isHidden = false
        } else {
            personalError.isHidden = true
            // Check if password == confirm password
            if password.text! != confirmPassword.text! {
                personalError.text = "Password Confirmation does not match!"
                personalError.isHidden = false
            }
            
            let fname = firstName.text!
            let lname  = lastName.text!
			username = fname + " " + String(lname.characters[lname.characters.startIndex]) + "."
        }
        
        return !personalError.isHidden
    }
    
    // Checks if any address sections empty
    func addressErrorFinder() -> Bool {
        addressErrorFound = false
        var errorMessage = ""
        
        if (addressOne.text?.isEmpty)! {
            errorMessage += "Address Line 1"
            addressErrorFound = true
        }
        if (city.text?.isEmpty)! {
            errorMessage += errorMessage.isEmpty ? "" : ", "
            errorMessage += "City"
            addressErrorFound = true
        }
        if (state.text?.isEmpty)! {
            errorMessage += errorMessage.isEmpty ? "" : ", "
            errorMessage += "State"
            addressErrorFound = true
        }
        if (zipcode.text?.isEmpty)! {
            errorMessage += errorMessage.isEmpty ? "" : ", "
            errorMessage += "Zip Code"
            addressErrorFound = true
        }
        if addressErrorFound {
            errorMessage += " required."
            addressError.text = errorMessage
            addressError.isHidden = false
        } else {
            addressError.isHidden = true
        }
        return !addressError.isHidden
        
    }
    
    func calculateAge() {
        let today = Date()
        let dob_string = month.text! + "/" + day.text! + "/" + year.text!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyy"
        let dob = dateFormatter.date(from: dob_string)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let calculateAge = calendar.components(.year, from: dob!, to: today, options: [])
		_ = calculateAge.year
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "completeRegToHome" {
            if let hv = segue.destination as? HomeView {
				hv.signedIn = true
                hv.uName = username
				//hv.updateUserName(username)
            }
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

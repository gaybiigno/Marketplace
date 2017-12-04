//
//  UploadImageView.swift
//  Marketplace
//
//  Created by student on 11/29/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class UploadImageView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var mainImage: UIImageView!
	
	@IBOutlet weak var errorLabel: UILabel!
	@IBOutlet weak var imgCountLabel: UILabel!
	
    let MAX_IMAGES = 8
    let imagePicker = UIImagePickerController()
    
	var allImages: [UIImage] = []
	
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
		errorLabel.isHidden = true
        start()
    }
    
    func start() {
        addButton.addTarget(self, action: #selector(clickNew(_:)), for: .touchUpInside)
    }
	
	func numImages() -> Int {
		return allImages.count
	}
	
	func displayError() -> Bool {
		return numImages() == 0 ? true : false
//		if numImages() == 0 {
//			self.errorLabel.isHidden = false
//			return true
//		}
//		self.errorLabel.isHidden = true
//		return false
	}
    
    @objc func clickNew(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            allImages.append(pickedImage)
			imgCountLabel.text = String(numImages())
			showAllImages()
            if numImages() == 1 {
                mainImage.contentMode = .scaleToFill
                mainImage.image = pickedImage
				
            } 
            if numImages() == MAX_IMAGES {
                addButton.isHidden = true
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func showAllImages() {
        let heightWidth = 60
		if numImages() == 0 {
			let defaultPic = UIImage(named: "PhotoIcon")
			mainImage.image = defaultPic
		}
		

        for i in 1 ..< MAX_IMAGES {
            let y_value = i > 4 ? 95 : 29
            let x_value = i > 4 ? (146 + ((i - 5) * heightWidth)) : (146 + ((i - 1) * heightWidth))
            let currImageView = UIImageView(frame: CGRect(x: x_value, y: y_value, width: heightWidth, height: heightWidth))
            currImageView.contentMode = .scaleToFill
            
            if i >= numImages() {
                if let defaultPic = UIImage(named: "PhotoIcon") {
                    currImageView.image = defaultPic
                    currImageView.layer.opacity = 0.2
                }
            } else {
                currImageView.image = allImages[i]
            }
            view.addSubview(currImageView)
        }
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

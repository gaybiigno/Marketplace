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
    
    let MAX_IMAGES = 8
    let imagePicker = UIImagePickerController()
    
    var allImages: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self

        start()
    }
    
    func start() {
        addButton.addTarget(self, action: #selector(clickNew(_:)), for: .touchUpInside)
    }
    
    @objc func clickNew(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            allImages.append(pickedImage)
            if allImages.count == 1 {
                mainImage.contentMode = .scaleToFill
                mainImage.image = pickedImage
                //showAllImages()
            } else {
                showAllImages()
            }
            
            if allImages.count == MAX_IMAGES {
                addButton.isHidden = true
            }
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func showAllImages() {
        let numImages = allImages.count
        
        let hw = 60

        for i in 1 ..< MAX_IMAGES {
            let y_value = i > 4 ? 95 : 29
            let x_value = i > 4 ? (146 + ((i - 5) * hw)) : (146 + ((i - 1) * hw))
            let currImageView = UIImageView(frame: CGRect(x: x_value, y: y_value, width: hw, height: hw))
            currImageView.contentMode = .scaleToFill
            
            if i >= numImages {
                if let defaultPic = UIImage(named: "PhotoIcon") {
                    currImageView.image = defaultPic
                    currImageView.layer.opacity = 0.6
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

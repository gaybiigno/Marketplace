//
//  UploadImageView.swift
//  Marketplace
//
//  Created by student on 11/29/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit
import Photos
import Foundation

class UploadImageView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var mainImage: UIImageView!
	
	@IBOutlet weak var imgCountLabel: UILabel!
    
    weak var delegate: ImageHandler?
	
    let MAX_IMAGES = 8
    let imagePicker = UIImagePickerController()
	
	let uploadTable = UploadItemTableView()
	
	var allImages = [UIImage]()
    var imgURL: NSURL!
    
    var imageData: Data!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self

		if numImages() != 0 {
			mainImage.contentMode = .scaleToFill
			mainImage.image = allImages[0]
		}
		
		showAllImages()
		
        start()
    }
    
    func upload() {
        let urlString = "http://localhost:8181/pics/upload"
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        var mutableURLRequest = URLRequest(url: NSURL(string: urlString) as! URL)
        
        mutableURLRequest.httpMethod = "POST"
        
        let boundaryConstant = "----------------12345"
        let contentType = "multipart/form-data;boundary=" + boundaryConstant
        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        var uploadData = Data()
        
        uploadData.append("\r\n--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
        uploadData.append("Content-Disposition: form-data; name=\"picture\"; filename=\"file.png\"\r\n".data(using: String.Encoding.utf8)!)
        uploadData.append("Content-Type: image/png\r\n\r\n".data(using: String.Encoding.utf8)!)
        uploadData.append(imageData!)
        uploadData.append("\r\n--\(boundaryConstant)--\r\n".data(using: String.Encoding.utf8)!)
        
        mutableURLRequest.httpBody = uploadData as Data
        
        
        let task1 = session.dataTask(with: mutableURLRequest, completionHandler: { (data, response, error) -> Void in
            if error == nil {
                print("image uploaded")
            } else {
                print("image not uploaded")
            }
        })
        //let task = session.dataTask(with: mutableURLRequest)
        
        task1.resume()
    }
    
    func createBody(with parameters: [String: String]?, filePathKey: String, paths: [String], boundary: String) throws -> Data {
        var body = Data()
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value)\r\n")
            }
        }
        
        for path in paths {
            let url = URL(fileURLWithPath: path)
            let filename = url.lastPathComponent
            let data = try Data(contentsOf: url)
            let mimetype = "image/png"//mimeType(for: path)
            
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n")
            body.append("Content-Type: \(mimetype)\r\n\r\n")
            body.append(data)
            body.append("\r\n")
        }
        
        body.append("--\(boundary)--\r\n")
        return body
    }
    
    func uploadImage(urlString: String, image: UIImage?) {
//        let request: URLRequest
//
//        do {
//            request = try createRequestBodyWith(parameters: [:], boundary: generateBoundaryString())
//        } catch {
//            print(error)
//            return
//        }
//        print(request.httpBody)
//        print(String(describing: request.httpBody))
//        print(request.httpBody?.base64EncodedString())
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard error == nil else {
//                // handle error here
//                print(error!)
//                return
//            }
//
//            // if response was JSON, then parse it
//
//            do {
//                let responseDictionary = try JSONSerialization.jsonObject(with: data!)
//                print("success == \(responseDictionary)")
//
//                // note, if you want to update the UI, make sure to dispatch that to the main queue, e.g.:
//                //
//                // DispatchQueue.main.async {
//                //     // update your UI and model objects here
//                // }
//            } catch {
//                print(error)
//
//                let responseString = String(data: data!, encoding: .utf8)
//                print("responseString = \(responseString)")
//            }
//        }
//        task.resume()
    }
    
    
    func start() {
        addButton.addTarget(self, action: #selector(clickNew(_:)), for: .touchUpInside)
    }
	
	func numImages() -> Int {
		return allImages.count
	}
	
	func displayError() -> Bool {
		return numImages() == 0 ? true : false
	}
    
    @objc func clickNew(_ sender: UIButton) {
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
            let imageURL = info[UIImagePickerControllerReferenceURL] as? NSURL
            print(imageURL)
            imageData = UIImagePNGRepresentation(pickedImage)!
            let imgStr = imageData.base64EncodedString()
            imgURL = imageURL
            upload()
//            uploadImage(urlString: (imageURL?.absoluteString)!, image: pickedImage)
            allImages.append(pickedImage)
            delegate?.setImages(pickedImage)
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
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
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

extension Data {
    
    /// Append string to NSMutableData
    ///
    /// Rather than littering my code with calls to `dataUsingEncoding` to convert strings to NSData, and then add that data to the NSMutableData, this wraps it in a nice convenient little extension to NSMutableData. This converts using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `NSMutableData`.
    
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}

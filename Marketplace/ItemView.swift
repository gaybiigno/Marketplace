//
//  ItemView.swift
//  Marketplace
//
//  Created by Gaybriella Igno on 11/8/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class ItemView: UIViewController {
	
	// Item title max chars SHOULD BE 48
	@IBOutlet weak var itemTitle: UITextView!
	
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet var imageView: UIImageView!
	
	// Item description max chars is 1000
	@IBOutlet var itemDescription: UITextView!
	
	@IBOutlet var tagViewBox: UIView!
	
	@IBOutlet var profilePicture: UIImageView!
	
	@IBOutlet weak var postedByLabel: UILabel!
	
	@IBOutlet weak var msgSellerButton: UIButton!
	
	let imageModel = ImageModel()
	
	var swipeLeft = UISwipeGestureRecognizer()
	
	var swipeRight = UISwipeGestureRecognizer()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func displayCurrentImage() {
		if let image = imageModel.currentImage()  {
			imageView.image = image
		}
	}
	
	func start() {
		displayCurrentImage()
		msgSellerButton.layer.cornerRadius = 5
	}
	
	@objc func next() {
		imageModel.next()
		displayCurrentImage()
	}
	
	@objc func prev() {
		imageModel.next()
		displayCurrentImage()
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

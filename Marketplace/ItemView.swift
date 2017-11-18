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
	
	@IBOutlet weak var itemPriceLabel: UILabel!
	@IBOutlet var itemImageView: UIImageView!
	@IBOutlet var itemDescription: UITextView!
	@IBOutlet weak var imageCounterLabel: UILabel!
	
	@IBOutlet var tagViewBox: UIView!
	@IBOutlet weak var itemCategory: UILabel!
	@IBOutlet weak var itemTags: UITextView!
	
	
	@IBOutlet var profilePicture: UIImageView!
	@IBOutlet weak var postedByLabel: UILabel!
	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var ratingLabel: UILabel!
	
	@IBOutlet weak var msgSellerButton: UIButton!
	
	let imageModel = ItemModel()
	
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
			itemImageView.image = image
			let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(next(_:)))
			swipeLeft.direction = .left
			itemImageView.addGestureRecognizer(swipeLeft)
			let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(prev(_:)))
			swipeRight.direction = .right
			itemImageView.addGestureRecognizer(swipeRight)
		}
	}
	
	func start() {
		setImageCounter()
		displayCurrentImage()
		msgSellerButton.layer.cornerRadius = 5
		itemPriceLabel.layer.masksToBounds = true
		itemPriceLabel.layer.mask?.cornerRadius = 5
	}
	
	@objc func next(_ sender: UIImageView) {
		imageModel.nextPic()
		displayCurrentImage()
		setImageCounter()
	}
	
	@objc func prev(_ sender: UIImageView) {
		imageModel.previousPic()
		displayCurrentImage()
		setImageCounter()
	}
	
	func setItemCategory() {
		itemCategory.text = "Main Category → Sub Category"
	}
	
	func setItemTitle() {
		itemTitle.text = "Here is the item title!"
	}
	
	func setImageCounter() {
		let title = String(imageModel.currentImagePosition()) + "/" + String(imageModel.numberOfImages())
		imageCounterLabel.text = title
	}
	
//	func setItemTags() {
//		// set tags
//	}
	

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

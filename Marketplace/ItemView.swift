//
//  ItemView.swift
//  Marketplace
//
//  Created by Gaybriella Igno on 11/8/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class ItemView: UIViewController {
	
	@IBOutlet weak var scrollView: UIScrollView!
	
	// Item title max chars SHOULD BE 48
	@IBOutlet weak var itemTitle: UITextView!
	
	@IBOutlet weak var itemPriceLabel: UILabel!
	@IBOutlet var itemImageView: UIImageView!
	@IBOutlet var itemDescription: UITextView!
	@IBOutlet weak var imageCounterLabel: UILabel!
	
	@IBOutlet var tagViewBox: UIView!
	@IBOutlet weak var itemQuantity: UILabel!
	@IBOutlet weak var itemCategory: UILabel!
	@IBOutlet weak var itemTags: UITextView!
	
	@IBOutlet var profilePicture: UIImageView!
	@IBOutlet weak var postedByLabel: UILabel!
	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var ratingLabel: UILabel!
	
	@IBOutlet weak var msgSellerButton: UIButton!
	
	let itemModel = ItemModel()
    let userModel = UserModel()
	
	var editView = false
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.scrollView.backgroundColor = UIColor.white
		scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 200)
		start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func displayCurrentImage() {
		if let image = itemModel.currentImage()  {
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
		
		
		itemPriceLabel.layer.mask?.cornerRadius = 10
		itemPriceLabel.layer.masksToBounds = true
		itemPriceLabel.layer.mask?.cornerRadius = 5
		msgSellerButton.layer.cornerRadius = 5
		
		if !editView {
			setItemQuantity()
			setImageCounter()
			setItemPrice()
			setItemTitle()
			setItemCategory()
			setItemDescription()
			displayCurrentImage()
			setUserInfo()
			msgSellerButton.addTarget(self, action: #selector(clickMessage(_:)), for: .touchUpInside)
		} else {
			
			profilePicture.isHidden = true
			postedByLabel.isHidden = true
			usernameLabel.isHidden = true
			ratingLabel.isHidden = true
			let orig = msgSellerButton.frame.origin
			msgSellerButton.frame.origin = CGPoint(x: orig.x, y: orig.y - 75.0)
			msgSellerButton.setTitle("Edit", for: .normal)
			msgSellerButton.addTarget(self, action: #selector(clickEdit(_:)), for: .touchUpInside)
		}
	}
	
	@objc func next(_ sender: UIImageView) {
		itemModel.nextPic()
		displayCurrentImage()
		setImageCounter()
	}
	
	@objc func prev(_ sender: UIImageView) {
		itemModel.previousPic()
		displayCurrentImage()
		setImageCounter()
	}
	
	@objc func clickEdit(_ sender: UIButton) {
		self.performSegue(withIdentifier: "editItem", sender: self)
	}
	
	@objc func clickMessage(_ sender: UIButton) {
		self.performSegue(withIdentifier: "itemToMsg", sender: self)
	}
	
	func setItemCategory() {
		itemCategory.text = itemModel.getCategory()
	}
	
	func setItemTitle() {
		itemTitle.text = itemModel.getTitle()
	}
	
	func setItemPrice() {
		let price = "$" + String(itemModel.getPrice())
		itemPriceLabel.text = price
	}
	
	func setImageCounter() {
		let title = String(itemModel.currentImagePosition()) + "/" + String(itemModel.numberOfImages())
		imageCounterLabel.text = title
	}
	
	func setItemDescription() {
		itemDescription.text = itemModel.getDescription()
	}
	
	func setItemQuantity() {
		itemQuantity.text = String(itemModel.getQuantity())
	}
    
    func setItemTags() {
		itemTags.text = itemModel.getTags()
    }
    
    func setUserInfo() {
        profilePicture.image = userModel.getProfilePic()
        usernameLabel.text = userModel.getUserName()
        ratingLabel.text = "Rating:     " + String(userModel.getRating()) + "/10"
    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let vc = segue.destination as? SendMessageView,
			segue.identifier == "itemToMsg" {
			vc.setDefaultValues(userModel.getUserName(), item: itemModel.getTitle(), vc: self)
		}
		if let vc = segue.destination as? UploadItemTableView,
			segue.identifier == "editItem" {
			
			
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

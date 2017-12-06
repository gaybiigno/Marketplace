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
	
	
	@IBOutlet weak var tagTitle: UILabel!
	@IBOutlet weak var ageTitle: UILabel!
	@IBOutlet weak var ageLabel: UILabel!
	
	@IBOutlet var profilePicture: UIImageView!
	@IBOutlet weak var postedByLabel: UILabel!
	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var ratingLabel: UILabel!
	
	@IBOutlet weak var msgSellerButton: UIButton!
	
	let itemModel = ItemModel()
    let userModel = UserModel()
	
	var editView = false
	var hasValues = false
	
	var imageArray = [UIImage]()
	var givenTitle = ""
	var descrip = ""
	var price = Float(0.0)
	var tags = [String]()
	var category = ""
	var quantity = 0
	var age = 0
	
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
		
		//if !hasValues {
			setItemQuantity()
			setImageCounter()
			setItemPrice()
			setItemTitle()
			setItemCategory()
			setItemDescription()
			setItemTags()
			setItemAge()
		//}
		
		if !editView {
			setUserInfo()
			msgSellerButton.addTarget(self, action: #selector(clickMessage(_:)), for: .touchUpInside)
		} else {
			itemModel.setImages(Imgs: imageArray)
			profilePicture.isHidden = true
			postedByLabel.isHidden = true
			usernameLabel.isHidden = true
			ratingLabel.isHidden = true
			let orig = msgSellerButton.frame.origin
			msgSellerButton.frame.origin = CGPoint(x: orig.x, y: orig.y - 75.0)
			msgSellerButton.setTitle("Edit", for: .normal)
			msgSellerButton.addTarget(self, action: #selector(clickEdit(_:)), for: .touchUpInside)
		}
		displayCurrentImage()
	}
	
	func setItemValues(Urls: Bool, ImageArray: [UIImage], Title: String,
	                   Description: String, Price: Float, Tags: [String],
	                   Category: String, Quantity: Int, Age: Int) {
		itemModel.setItemValues(Urls: Urls, ImageArray: ImageArray, Title: Title, Description: Description, Price: Price, Tags: Tags, Category: Category, Quantity: Quantity, Age: Age)
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
		itemCategory.text = editView ? category : itemModel.getCategory()
	}
	
	func setItemTitle() {
		itemTitle.text = editView ? givenTitle : itemModel.getTitle()
	}
	
	func setItemPrice() {
		let modPrice = "$" + String(itemModel.getPrice())
		let getPrice = "$" + String(price)
		itemPriceLabel.text = editView ? getPrice : modPrice
	}
	
	func setImageCounter() {
		let title = String(itemModel.currentImagePosition()) + "/" + String(itemModel.numberOfImages())
		imageCounterLabel.text = title
	}
	
	func setItemDescription() {
		itemDescription.text = editView ? descrip : itemModel.getDescription()
	}
	
	func setItemQuantity() {
		itemQuantity.text = editView ? String(quantity) : String(itemModel.getQuantity())
	}
    
    func setItemTags() {
		let stringRep = tags.joined(separator: "  ")
		
		itemTags.text = editView ? stringRep : itemModel.getTags()
		
		if itemTags.text.isEmpty {
			tagTitle.isHidden = true
		}
    }
	
	func setItemAge() {
		ageLabel.text = editView ? String(age) : String(itemModel.getAge())
		
		if ageLabel.text == "0" {
			ageTitle.isHidden = true
			ageLabel.isHidden = true
		}
	}
    
    func setUserInfo() {
        profilePicture.image = userModel.getProfilePic()
        usernameLabel.text = userModel.getUserName()
        ratingLabel.text = "Rating:     " + String(userModel.getRating()) + "/10"
    }
	
	@IBAction func clickedBack(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}
	
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let vc = segue.destination as? SendMessageView,
			segue.identifier == "itemToMsg" {
			vc.setDefaultValues(userModel.getUserName(), item: itemModel.getTitle(), vc: self)
		}
		if let vc = segue.destination as? UploadItemTableView,
			segue.identifier == "editItem" {
			vc.editingItem = true
			vc.itemPrice = String(price)
			vc.itemTitle = itemTitle.text
			vc.itemDescription = itemDescription.text
			vc.quantity = Int(itemQuantity.text!)!
			vc.itemImages = imageArray
			vc.age = age
			vc.tagString = tags.joined(separator: "  ")
			vc.cat = category
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

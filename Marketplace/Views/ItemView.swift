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
	
	
	@IBOutlet weak var purchaseButton: UIButton!
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
		
		itemPriceLabel.numberOfLines = 2
		itemPriceLabel.adjustsFontSizeToFitWidth = true
		itemPriceLabel.clipsToBounds = true
		itemPriceLabel.textAlignment = .left
		itemPriceLabel.baselineAdjustment = .alignCenters
		
		start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func displayCurrentImage() {
		if let img = UIImage(named: "PhotoIcon"), hasValues {
			itemImageView.image = img
		} else {
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
	}
	
	func start() {
		imageCounterLabel.text = "1/1"
		itemPriceLabel.layer.mask?.cornerRadius = 10
		itemPriceLabel.layer.masksToBounds = true
		purchaseButton.layer.cornerRadius = 5
		msgSellerButton.layer.cornerRadius = 5
		
		setItemQuantity()
		setImageCounter()
		setItemPrice()
		setItemTitle()
		setItemCategory()
		setItemDescription()
		setItemTags()
		setItemAge()
		
		if let img = UIImage(named: "PhotoIcon"), hasValues {
			imageArray.append(img)
		}
		
		purchaseButton.addTarget(self, action: #selector(clickPurchase(_:)), for: .touchUpInside)
		
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
	
	@objc func clickPurchase(_ sender: UIButton){
		let alertController = UIAlertController(title: "Sucess!", message: "Purchase successful", preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "Continue Shopping", style: UIAlertActionStyle.default) {
			UIAlertAction in
			self.performSegue(withIdentifier: "purchaseToHome", sender: self)
		})
		alertController.addAction(UIAlertAction(title: "View Purchased Item", style: UIAlertActionStyle.cancel) {
			UIAlertAction in
			self.purchaseButton.alpha = 0.4
			self.purchaseButton.isEnabled = false
		})
	UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
		
		
		
	}
	
	func setItemCategory() {
		if hasValues {
			itemCategory.text = hasValues ? category : itemModel.getCategory()
		} else {
			itemCategory.text = editView ? category : itemModel.getCategory()
		}
	}
	
	func setItemTitle() {
		if hasValues {
			itemTitle.text = hasValues ? givenTitle : itemModel.getTitle()
		} else {
			itemTitle.text = editView ? givenTitle : itemModel.getTitle()
		}
	}
	
	func setItemPrice() {
		let modPrice = "$" + String(itemModel.getPrice())
		let getPrice = "$" + String(price)
		if hasValues {
			itemPriceLabel.text = hasValues ? getPrice : modPrice
		} else {
			itemPriceLabel.text = editView ? getPrice : modPrice
		}
			
	}
	
	func setImageCounter() {
		if hasValues {
			imageCounterLabel.text = "1/1"
		} else {
			let title = String(itemModel.currentImagePosition()) + "/" + String(itemModel.numberOfImages())
			imageCounterLabel.text = title
		}
	}
	
	func setItemDescription() {
		if hasValues {
			itemDescription.text = hasValues ? descrip : itemModel.getDescription()
		} else {
			itemDescription.text = editView ? descrip : itemModel.getDescription()
		}
	}
	
	func setItemQuantity() {
		if hasValues {
			itemQuantity.text = hasValues ? String(quantity) : String(itemModel.getQuantity())
		} else {
			itemQuantity.text = editView ? String(quantity) : String(itemModel.getQuantity())
		}
	}
    
    func setItemTags() {
		if !hasValues {
			let stringRep = tags.joined(separator: "  ")
			
			itemTags.text = editView ? stringRep : itemModel.getTags()
		}
		
		if itemTags.text.isEmpty {
			tagTitle.isHidden = true
		}
    }
	
	func setItemAge() {
		if hasValues {
			ageLabel.text = hasValues ? String(age) : String(itemModel.getAge())
		} else {
			ageLabel.text = editView ? String(age) : String(itemModel.getAge())
		}
		
		
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
			vc.setDefaultValues(userModel.getUserName(), item: itemTitle.text, vc: self)
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
		if let vc = segue.destination as? HomeView,
			segue.identifier == "purchaseToHome" {
			vc.signedIn = true
			vc.uName = "UPD IN ITEMVIEW"
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

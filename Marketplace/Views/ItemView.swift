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
	
	var guestBrowsing = true
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
    
    var sellerEmail = ""
    var itemId = 0
    var currentUserEmail = ""
    var currentUser: User!
    var gettingTags = false
    
    var downloadAssistant: Download!
    var userSchema: UserSchemaProcessor!
    var userDataSource: UserDataSource!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(currentUserEmail)
        
		self.scrollView.backgroundColor = UIColor.white
		scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 300)
        downloadAssistant = Download(withURLString: buildURLString())
        downloadAssistant.addObserver(self, forKeyPath: "dataFromServer", options: .old, context: nil)
        downloadAssistant.download_request()
        
        gettingTags = true
        downloadAssistant = Download(withURLString: buildTagURLString())
        downloadAssistant.addObserver(self, forKeyPath: "dataFromServer", options: .old, context: nil)
        downloadAssistant.download_request()
        itemPriceLabel.adjustsFontSizeToFitWidth = true
        itemPriceLabel.clipsToBounds = true
        itemPriceLabel.baselineAdjustment = .alignCenters

		start()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if gettingTags == false {
            userSchema = UserSchemaProcessor(userModelJSON: downloadAssistant.dataFromServer! as! [AnyObject])
            userDataSource = UserDataSource(dataSource: userSchema.getAllUsers())
            userDataSource.consolidate()
            currentUser = userDataSource.userAt(0)!
            print(currentUser)
            downloadAssistant.removeObserver(self, forKeyPath: "dataFromServer")
            print(currentUser)
            
        } else {
            gettingTags = false
            let tagsSchema = TagSchemaProcessor(tagsModelJSON: downloadAssistant.dataFromServer! as! [AnyObject])
            let tagsDataSource = TagsDataSource(dataSource: tagsSchema.getAllTags())
            tagsDataSource.consolidate()
            let curTags = tagsDataSource.tags
            var numTags = curTags?.count
            for tag in curTags! {
                numTags = numTags! - 1
                itemTags.text = String(itemTags.text) + tag.tag!
                if numTags! > 0 {
                    itemTags.text = String(itemTags.text) + ", "
                }
            }
            downloadAssistant.removeObserver(self, forKeyPath: "dataFromServer")
        }
    }
    
    func buildURLString() -> String {
        var url = Download.baseURL
        url += "/users/"
        url += "?email=" + sellerEmail
        url += "&apikey=" + Download.apikey
        return url
    }
    
    func buildTagURLString() -> String {
        var url = Download.baseURL + "/tags/item_id/"
        url += "?item_id=" + String(itemId)
        return url
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
		
		if guestBrowsing {
			print("guestBrowsing in item:", guestBrowsing)
			msgSellerButton.isHidden = true
			purchaseButton.isHidden = true
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
        alertController.addAction(UIAlertAction(title: "Rate Seller", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.performSegue(withIdentifier: "toRateSeller", sender: self)
        })
		alertController.addAction(UIAlertAction(title: "View Purchased Item", style: UIAlertActionStyle.cancel) {
			UIAlertAction in
			self.purchaseButton.alpha = 0.4
			self.purchaseButton.isEnabled = false
		})
        
        
        self.present(alertController, animated: true, completion: nil)
	}
	
	func setItemCategory() {
		if hasValues {
			itemCategory.text = hasValues ? category : itemModel.getCategory()
            itemCategory.text = itemCategory.text?.replacingOccurrences(of: "_", with: " ").replacingOccurrences(of: "and", with: "&")
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
        
        let modPrice = "$" + String(round(itemModel.getPrice()*100)/100)
        var getPrice = "$"
        if Int(price*10)*10 >= Int(price*100) {
            getPrice += String(price) + "0"
        } else {
            getPrice += String(price)
        }
        
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
		/*
		if itemTags.text.isEmpty {
			tagTitle.isHidden = true
			itemTags.isHidden = true
			let heightToSub = itemTags.frame.height
			
			let moveUpObjects = [ageTitle, ageLabel, profilePicture, postedByLabel, usernameLabel, ra]
			
			ageTitle.center = CGPoint(ageTitle.center.x, ageTitle.center.y - heightToSub)
			ageLabel.center = CGPoint(ageLabel.center.x, ageLabel.center.y - heightToSub)
			let tOrigin = tagViewBox.frame.origin
			tagViewBox.frame = CGRect(x: tOrigin.x, y: tOrigin.y, width: tagViewBox.frame.width, height: tagViewBox.frame.height - heightToSub)
		}
     */
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
        // TODO pic
        profilePicture.image = userModel.getProfilePic()
        usernameLabel.text = currentUser.first_name! + " " + currentUser.last_name![0] + "."
        ratingLabel.text = "Rating:     " + String(currentUser.rating) + "/10"
    }
	
	@IBAction func clickedBack(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let vc = segue.destination as? SendMessageView,
			segue.identifier == "itemToMsg" {
            if !guestBrowsing {
//                vc.buyerEmail = currentUserEmail
//                vc.sellerEmail = sellerEmail
                vc.setDefaultValues(nil, nil, itemTitle.text, currentUserEmail, sellerEmail)
            }
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
            // send email
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

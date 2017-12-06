//
//  ImageModel.swift
//  Marketplace
//
//  Created by Gaybriella Igno on 11/12/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class ItemModel: NSObject {
	
	private var imageArrayURL = ["https://st.depositphotos.com/1605004/1559/v/950/depositphotos_15599555-stock-illustration-new-item-stamp.jpg", "https://calendarmedia.blob.core.windows.net/assets/af1c2286-2a2a-40be-b0f4-75c09bd32dc1.png", "https://regmedia.co.uk/2015/09/01/sale_648.jpg?x=442&y=293&crop=1"]
	
	private var currentIdx = 0
	
	private var imageArray = [UIImage]()
	private var title = ""
	private var descrip = ""
	private var price = Float(0.0)
	private var tags = [String]()
	private var category = ""
	private var quantity = 0
	private var age = 0
	
	var urls = false
	
	func setItemValues(Urls: Bool, ImageArray: [UIImage], Title: String,
	                   Description: String, Price: Float, Tags: [String],
	                   Category: String, Quantity: Int, Age: Int) {
		urls = Urls
		imageArray = ImageArray
		title = Title
		descrip = Description
		price = Price
		tags = Tags
		category = Category
		quantity = Quantity
		age = Age
	}
	
	func setImages(Imgs: [UIImage]) {
		imageArray = Imgs
	}
    
    func getMainImage() -> UIImage? {
		if !urls {
			return imageArray[0]
		} else {
			if let url = URL(string: imageArrayURL[0]), let data = try? Data(contentsOf: url),
				let image = UIImage(data: data), urls {
				return image
			}
		}
        return nil
    }
	
	func currentImage() -> UIImage? {
		if !urls {
			return imageArray[currentIdx]
		} else {
			if let url = URL(string: imageArrayURL[currentIdx]), let data = try? Data(contentsOf: url),
				let image = UIImage(data: data), urls {
				return image
			}
		}
		
		return nil
	}
	
	func numberOfImages() -> Int {
		return imageArray.count
	}
	
	func currentImagePosition() -> Int {
		return currentIdx + 1
	}
	
	func previousPic() {
		if currentIdx != 0 {
			currentIdx -= 1
		}
	}
	
	func nextPic() {
		if currentIdx != numberOfImages() - 1 {
			currentIdx += 1
		}
	}
	
	func getTitle() -> String {
		if !urls {
			return title
		}
		return "Example Item For Sale"
	}
	
	func getPrice() -> Float {
		if !urls {
			return price
		}
		return 25.99
	}
	
	func getCategory() -> String {
		if !urls {
			return category
		}
		return "Main Category"
	}
	
	func getQuantity() -> Int {
		if !urls {
			return quantity
		}
		return 892
	}
	
	func getTags() -> String {
		if !urls {
			let tag = tags
			var stringOfTags = ""
			for t in tag {
				stringOfTags += t + " "
			}
			return stringOfTags
		}
		return ""
	}
	
	func getDescription() -> String {
		if !urls {
			return description
		}
		return "This fake item is NOT real and therefore should not " +
			"be purchased for actual money. It's completely imaginary " +
			"and has no monetary value in the real world. Like maybe " +
			"it has come sentimental value because I'll be able to " +
			"remember the time I sat and wrote out this description for " +
			"an item that doesn't exist. Ah the memories, the sweet, " +
			"sweet memories. In other news, I found a bump on my " +
			"finger and got really worried I had a cyst or something " +
			"but instead it was just a callus. Turns out, I had been " +
			"playing so many video games on my bfs xbox that holding " +
			"the controller literally game me a callus. Probably bc " +
			"I'm used to PS4 controllers and they're smaller/lighter. " +
			"No idea why you actually have read to this point but thanks " +
			"for listening. Good day!"
	}
	
	func getAge() -> Int {
		if !urls {
			return age
		}
		return 18
	}
	
	
}

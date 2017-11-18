//
//  ImageModel.swift
//  Marketplace
//
//  Created by Gaybriella Igno on 11/12/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class ItemModel: NSObject {
	
//	fileprivate let itemURL = "https://st.depositphotos.com/1605004/1559/v/950/depositphotos_15599555-stock-illustration-new-item-stamp.jpg"
//	fileprivate let itemURL2 = "https://calendarmedia.blob.core.windows.net/assets/af1c2286-2a2a-40be-b0f4-75c09bd32dc1.png"
//	fileprivate let itemURL3 = "https://regmedia.co.uk/2015/09/01/sale_648.jpg?x=442&y=293&crop=1"
	
	private var itemArray = ["https://st.depositphotos.com/1605004/1559/v/950/depositphotos_15599555-stock-illustration-new-item-stamp.jpg", "https://calendarmedia.blob.core.windows.net/assets/af1c2286-2a2a-40be-b0f4-75c09bd32dc1.png", "https://regmedia.co.uk/2015/09/01/sale_648.jpg?x=442&y=293&crop=1"]
	
	private var currentIdx = 0
	
	func currentImage() -> UIImage? {
		if let url = URL(string: itemArray[currentIdx]), let data = try? Data(contentsOf: url),
			let image = UIImage(data: data) {
			return image
		}
		return nil
		
	}
	
	func numberOfImages() -> Int {
		return itemArray.count
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
		
		//currentIdx = (currentIdx + 1) % imageNames.count
	}
	
	
}

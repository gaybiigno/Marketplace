//
//  ImageModel.swift
//  Marketplace
//
//  Created by Gaybriella Igno on 11/12/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class ItemModel: NSObject {
	
	fileprivate let itemURL = "https://st.depositphotos.com/1605004/1559/v/950/depositphotos_15599555-stock-illustration-new-item-stamp.jpg"
	
	private var currentIdx = 0
	
	
//	func numberOfImages() -> Int {
//		return imageNames.count
//	}
	
	func currentImage() -> UIImage? {
		if let url = URL(string: itemURL), let data = try? Data(contentsOf: url),
			let image = UIImage(data: data) {
			return image
		}
		return nil
		
	}
	
	func currentImagePosition() -> Int {
		return currentIdx + 1
	}
	
	func previous() {
		if currentIdx == 0 {
			currentIdx = 3 //imageNames.count - 1
		} else {
			currentIdx -= 1
		}
	}
	
	func next() {
		currentIdx += 1 //currentIdx = (currentIdx + 1) % imageNames.count
	}
	
	
}

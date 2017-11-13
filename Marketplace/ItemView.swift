//
//  ItemView.swift
//  Marketplace
//
//  Created by Gaybriella Igno on 11/8/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class ItemView: UIViewController {
	
	let imageModel = ImageModel()
	var imageView = UIImageView(frame: CGRect(x: 7, y: 60, width: 400, height: 300))
	
	var swipeLeft = UISwipeGestureRecognizer()
	var swipeRight = UISwipeGestureRecognizer()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		start()
		
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func displayCurrentImage() {
		if let image = imageModel.currentImage()  {
			imageView.image = image
			self.view.addSubview(imageView)
			
		}
	}
	
	func start() {
		let title = UILabel(frame: CGRect(x: 30, y: 33, width: 400, height: 30))
		title.text = "ITEM TITLE GOES HERE"
		title.font = UIFont(name: "Avenir Next", size: 25.0)
		self.view.addSubview(title)

		displayCurrentImage()
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

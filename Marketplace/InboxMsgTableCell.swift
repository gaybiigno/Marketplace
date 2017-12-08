//
//  InboxMsgTableCell.swift
//  Marketplace
//
//  Created by Gaybriella Igno on 12/7/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class InboxMsgTableCell: UITableViewCell {

	@IBOutlet weak var msgSubject: UILabel!
	@IBOutlet weak var otherUserName: UILabel!
	@IBOutlet weak var msgIcon: UIImageView!
	
	 //var thisMessage: Message? = nil
	var originalCenter = CGPoint()
	var deleteOnDragRelease = false
	var originalFrame = CGRect()
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
//		let deleteHold = UILongPressGestureRecognizer(target: self, action: #selector(deleteThat(_:)))
//		deleteHold.minimumPressDuration = 1.0
//		deleteHold.delaysTouchesBegan = true
//		deleteHold.delegate = self
//		self.addGestureRecognizer(deleteHold)
		
		let deleteGesture = UIPanGestureRecognizer(target: self, action: #selector(deleteThread(_:)))
		deleteGesture.delegate = self
		self.addGestureRecognizer(deleteGesture)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func useMessage(_ img: UIImage, _ subject: String, _ otherUser: String, _ iconShown: Bool) {
		//itemImage.image = img
		msgSubject.text = subject
		otherUserName.text = otherUser
		msgIcon.isHidden = !iconShown
	}
	
	@objc func deleteThat(_ sender: UILongPressGestureRecognizer) {
		print("Long pressed dat bish")
		popUp()
	}
	
	@objc func deleteThread(_ recognizer: UIPanGestureRecognizer) {
		if recognizer.state == .began {
			// when the gesture begins, record the current center location
			originalCenter = center
		}
		// 2
		if recognizer.state == .changed {
			let translation = recognizer.translation(in: self)
			center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
			print("center now is: \(center)")
			
			// has the user dragged the item far enough to initiate a delete/complete?
			//recognizer.setTranslation(center, in: self)
			deleteOnDragRelease = center.x < originalCenter.x - 100.0
			//deleteOnDragRelease = frame.origin.x < frame.size.width / 2.0
			//print("in changed")
		}
		// 3
		if recognizer.state == .ended {
			print("in ended")
			// the frame this cell had before user dragged it
			originalFrame = CGRect(x: 0, y: frame.origin.y,
			                           width: bounds.size.width, height: bounds.size.height)
			if !deleteOnDragRelease {
				// if the item is not being deleted, snap back to the original location
				UIView.animate(withDuration: 0.2, animations: {self.frame = self.originalFrame})
			} else {
				popUp()
			}
		}
		
		
		
		
	}
	
	func popUp() {
		let alertController = UIAlertController(title: "Confirm Delete", message: "Are you sure you'd like to permanently delete this message thread?", preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.default) {
			UIAlertAction in
			self.deleteMessage()
			UIView.animate(withDuration: 0.2, animations: {self.frame = self.originalFrame})
		})
		alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
			UIAlertAction in
			UIView.animate(withDuration: 0.2, animations: {self.frame = self.originalFrame})
		})
		UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
	}
	
	
	
	func deleteMessage() {
		print("Message deleted!")
	}
	
	
	/*
	func useMessage(_ message: Message?) {
		thisMessage = message
		if let m = message {
			msgSubject.text = message?.subject
			cellPrice.text = String (describing: message?.price)
		} else {
			cellLabel.text = "Item not found!"
		}
	}
*/

}

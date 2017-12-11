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
    
    var subject: String!
    var content: String!
    var thisUserEmail: String!
    var otherUserEmail: String!
    
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // add a pan recognizer
//        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePann(_:)))
//        recognizer.delegate = self
//        addGestureRecognizer(recognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
    func useMessage(_ subject: String, _ thisUser: String, _ otherUser: String, _ msgContent: String, _ iconShown: Bool) {
		//itemImage.image = img
		self.subject = subject
		self.otherUserEmail = otherUser
        self.content = msgContent
        self.thisUserEmail = thisUser
        
        msgSubject.text = subject
        otherUserName.text = otherUserEmail
		msgIcon.isHidden = !iconShown
	}

	
	//MARK: - horizontal pan gesture methods
	@objc func handlePann(_ recognizer: UIPanGestureRecognizer) {
		// 1
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
        let inboxTable = InboxTableView()
        inboxTable.present(alertController, animated: true, completion: nil)
        //self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
		//UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
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

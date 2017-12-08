//
//  InboxMsgTableCell.swift
//  Marketplace
//
//  Created by Gaybriella Igno on 12/7/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class InboxMsgTableCell: UITableViewCell {

	@IBOutlet weak var itemImage: UIImageView!
	@IBOutlet weak var itemTitle: UILabel!
	@IBOutlet weak var otherUserName: UILabel!
	@IBOutlet weak var msgIcon: UIImageView!
	
	 //var thisMessage: Message? = nil
	var originalCenter = CGPoint()
	var deleteOnDragRelease = false
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func useMessage(_ img: UIImage, _ subject: String, _ otherUser: String, _ iconShown: Bool) {
		itemImage.image = img
		itemTitle.text = subject
		otherUserName.text = otherUser
		msgIcon.isHidden = !iconShown
	}
	
//	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//		super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//		// add a pan recognizer
//		var recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
//		recognizer.delegate = self
//		addGestureRecognizer(recognizer)
//	}
//
//	required init?(coder aDecoder: NSCoder) {
//		fatalError("init(coder:) has not been implemented")
//	}
	
	//MARK: - horizontal pan gesture methods
	@objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
		// 1
		if recognizer.state == .began {
			// when the gesture begins, record the current center location
			originalCenter = center
		}
		// 2
		if recognizer.state == .changed {
			let translation = recognizer.translation(in: self)
			center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
			// has the user dragged the item far enough to initiate a delete/complete?
			deleteOnDragRelease = frame.origin.x < -frame.size.width / 2.0
		}
		// 3
		if recognizer.state == .ended {
			// the frame this cell had before user dragged it
			let originalFrame = CGRect(x: 0, y: frame.origin.y,
			                           width: bounds.size.width, height: bounds.size.height)
			if !deleteOnDragRelease {
				// if the item is not being deleted, snap back to the original location
				UIView.animate(withDuration: 0.2, animations: {self.frame = originalFrame})
			}
		}
	}
	
//	override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//		if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
//			let translation = panGestureRecognizer.translation(in: superview!)
//			if fabs(translation.x) > fabs(translation.y) {
//				return true
//			}
//			return false
//		}
//		return false
//	}
	
	// Check if user is recipient or sender
//	func checkRole(_ recipient: String, _ sender: String) {
//
//	}
	
	/*
	func useMessage(_ message: Message?) {
		thisMessage = message
		if let m = message {
			itemTitle.text = message?.subject
			otherUserName = message?.item_name
			cellPrice.text = String (describing: message?.price)
		} else {
			cellLabel.text = "Item not found!"
		}
	}
*/

}

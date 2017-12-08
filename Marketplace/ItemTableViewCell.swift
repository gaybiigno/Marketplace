//
//  ItemTableViewCell.swift
//  Marketplace
//
//  Created by Gaybriella Igno on 11/22/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellPrice: UILabel!
    @IBOutlet weak var cellLabel: UILabel!
    
    var thisItem: Item? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //print("selected")
        //print(thisItem?.item_name)
        
        // Configure the view for the selected state
    }
    
    func useItem(_ item: Item?) {
        thisItem = item
        if let i = item {
            cellLabel.text = item?.item_name
            cellPrice.text = String (describing: item?.price)
        } else {
            cellLabel.text = "Item not found!"
        }
    }
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		let deleteGesture = UIPanGestureRecognizer(target: self, action: #selector(deleteThread(_:)))
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc func deleteThread(_ sender: UIButton) {
		let alertController = UIAlertController(title: "Confirm Delete", message: "Are you sure you'd like to permanently delete this message thread?", preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.default, handler: nil))
		alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
		
		//present(alertController, animated: true, completion: nil)
	}
	

    

}

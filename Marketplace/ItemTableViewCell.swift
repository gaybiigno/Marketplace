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
	
	
	
	

    

}

//
//  Handy.swift
//  Marketplace
//
//  Created by Gaybriella Igno on 11/9/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import Foundation
import UIKit



// Sets a "max length" variable - useful for month, date, quantity, etc.
private var __maxLengths = [UITextField: Int]()

extension UITextField {
	@IBInspectable var maxLength: Int {
		get {
			guard let l = __maxLengths[self] else {
				return Int.max //150 // (global default-limit. or just, Int.max)
			}
			return l
		}
		set {
			__maxLengths[self] = newValue
			addTarget(self, action: #selector(fix), for: .editingChanged)
		}
	}
	@objc func fix(textField: UITextField) {
		let t = textField.text
		textField.text = t?.safelyLimitedTo(length: maxLength)
	}
}

extension String
{
	func safelyLimitedTo(length n: Int)->String {
		let c = self.characters
		if (c.count <= n) { return self }
		return String( Array(c).prefix(upTo: n) )
	}
}

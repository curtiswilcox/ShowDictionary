//
//  String+isAlphanumeric.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 8/25/18.
//  Copyright © 2018 Curtis Wilcox. All rights reserved.
//

import Foundation

extension String {
	var isAlphanumeric: Bool {
		return (self.rangeOfCharacter(from: CharacterSet.alphanumerics) != nil)
	}
    
    func capitalizeFirstLetter() -> String {
        return "\(self.prefix(1).capitalized)\(self.dropFirst())"
    }

    /**
	Use this function to localize a string with a format
     - Parameter quantity: the number of (selves) there are
	 - Parameter comment: the comment belonging to the NSLocalizedString
     - Parameter capitalized: whether or not the result should be capitalized
	*/
    func localizeWithFormat(quantity number: Int, comment: String = "") -> String {
		return String.localizedStringWithFormat(NSLocalizedString(self, comment: comment), number)
	}
}

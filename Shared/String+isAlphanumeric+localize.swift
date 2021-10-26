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
        (self.rangeOfCharacter(from: CharacterSet.alphanumerics) != nil)
    }
    
    func alphanumeric() -> String {
        self.filter { String($0).isAlphanumeric }
    }
    
    func capitalizeFirstLetter() -> String {
        "\(self.prefix(1).capitalized)\(self.dropFirst())"
    }
    
    func firstLetter() -> String {
        let articles = ["the", "el", "los", "la", "las"] // TODO: this is bad
        let string = self.lowercased().filter { String($0).isAlphanumeric || $0.isWhitespace }
        for article in articles where string.hasPrefix("\(article) ") {
            return String(string.dropFirst(article.count + 1)).first!.uppercased()
        }
        return string.first!.uppercased()
    }
    
    /**
     Use this function to localize a string with a format
     - Parameter quantity: the number of (selves) there are
     - Parameter comment: the comment belonging to the NSLocalizedString
     - Parameter capitalized: whether or not the result should be capitalized
     */
    func localizeWithFormat(quantity number: Int, comment: String = "") -> String {
        String.localizedStringWithFormat(NSLocalizedString(self, comment: comment), number)
    }
}

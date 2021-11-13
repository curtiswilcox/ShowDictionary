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
        let articles = articles() // TODO: this is bad
        let string = self.lowercased().filter { String($0).isAlphanumeric || $0.isWhitespace }
        for article in articles {
            if string.hasPrefix("\(article) ") || (article.hasSuffix("'") && string.hasPrefix(article)) {
                return String(string.dropFirst(article.count + (article.hasSuffix("'") ? 0 : 1))).first!.uppercased()
            }
        }
        return string.first!.uppercased()
    }
    
    private func articles() -> [String] {
        switch Locale.current.description {
        case "en":
            return ["the"]
        case "es":
            return ["el", "la", "los", "las"]
        case "fr":
            return ["il, la, les, l'"]
        case "it":
            return ["il, la, lo, l', i, gli, le"]
        case "pt":
            return ["o", "a", "os", "as"]
        default:
            return []
        }
    }
    
    func withoutDiacritics(locale: Locale = .current) -> String {
        folding(options: .diacriticInsensitive, locale: locale)
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

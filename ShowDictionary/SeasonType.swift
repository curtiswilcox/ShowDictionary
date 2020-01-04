//
//  SeasonType.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 9/11/18.
//  Copyright © 2018 Curtis Wilcox. All rights reserved.
//

import Foundation

enum SeasonType: String, Codable, Identifiable {
	case season
	case series
	case book
	
    var id: String { rawValue }
    
    /*
     Utilize these fields when the original English name is required for localization of a larger string
     */
    var capSing: String {
        switch self {
        case .book: return "book"
        case .season: return "season"
        case .series: return "series"
        }
    }
    
    var lowPlur: String {
        switch self {
        case .book: return "books"
        case .season: return "seasons"
        case .series: return "series"
        }
    }
    
    /*
     Utilize these fields when localizing just the season type without a bigger string
     */
    var localizeCapSing: String {
        switch self {
        case .book: return "book".localizeWithFormat(quantity: 1).capitalized
        case .season: return "season".localizeWithFormat(quantity: 1).capitalized
        case .series: return "series".localizeWithFormat(quantity: 1).capitalized
        }
    }
    
    var localizeLowPlur: String {
        switch self {
        case .book: return "book".localizeWithFormat(quantity: 2)
        case .season: return "season".localizeWithFormat(quantity: 2)
        case .series: return "series".localizeWithFormat(quantity: 2)
        }
    }
	
//	func toString() -> String {
//		return self.rawValue.capitalized
//	}
	
//	func localizeCapSing(/*_ lang: AvailableLanguage*/) -> String {
//		return NSLocalizedString(self.toString(), comment: "\"\(self.toString())\" type of seasons, capitalized, singular")
//	}
	
//	func localizeLowPlur(/*lang: AvailableLanguage*/) -> String {
//		return NSLocalizedString(self.toString(), comment: "\"\(self.toString())\" type of seasons, lowercase, plural")
//	}
}

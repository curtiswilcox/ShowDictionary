////
////  AvailableLanguage.swift
////  ShowDictionary
////
////  Created by Curtis Wilcox on 6/17/19.
////  Copyright © 2019 Curtis Wilcox. All rights reserved.
////
//
//import Foundation
//
//enum AvailableLanguage: String {
//	case english = "en", spanish = "es"
//
//	init?(from str: String) {
//		switch str.lowercased() { //TODO: hardcoded numbers... try to fix
//		case "1": self = .english
//		case "2": self = .spanish
//		default: return nil
//		}
//	}
//
//	func toString() -> String {
//		switch self {
//		case .english:
//			return "English"
//		case .spanish:
//			return "Español"
//		}
//	}
//}

//
//  Date+new+written+toString.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 8/25/18.
//  Copyright © 2018 Curtis Wilcox. All rights reserved.
//

import Foundation

extension Date {
	
	init(hyphenated airdate: String) {
		self = Date.new(hyphenated: airdate)
	}
	
	static func new(hyphenated airdate: String) -> Date {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy/MM/dd"
		if let date = formatter.date(from: airdate) {
			return date
		} else {
			return formatter.date(from: "0001-01-01")!
		}
	}

  func written(/*lang: AvailableLanguage*/) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale.current
    formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMd", options: 0, locale: Locale.current)!
    return formatter.string(from: self)
	}

	func toString() -> String {
		let desc = self.description
		return String(desc.split(separator: " ")[0])
	}
}

//
//  SeasonType.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 10/26/21.
//  Copyright © 2021 wilcoxcurtis. All rights reserved.
//

import Foundation

enum SeasonType: String, Decodable {
    case book, season, series
    
    var rawValue: String {
        switch self {
        case .book:
            return String(localized: "book")
        case .season:
            return String(localized: "season")
        case .series:
            return String(localized: "series")
        }
    }
}

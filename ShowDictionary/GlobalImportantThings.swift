//
//  GlobalImportantThings.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 12/25/19.
//  Copyright © 2019 wilcoxcurtis. All rights reserved.
//

import Foundation

func getSeasonText(_ show: Show, _ season: Int) -> String {
    let preColon = "\(NSLocalizedString(show.typeOfSeasons.localizeCapSing, comment: "")) \(season)"
    if let title = show.seasonTitles?[season] {
        return "\(preColon): \(title)"
    }
    else { return preColon }
}

//
//  SeasonScrollMenu.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 10/28/21.
//

import SwiftUI

struct SeasonScrollMenu: View {
    @Binding var show: Show
    let availableSeasons: [Int]
    @Binding var scrollToSection: Int?
    let includeOuterMenu: Bool
    let episodeCount: (Int) -> Int
    
    var body: some View {
        if includeOuterMenu {
            Menu {
                seasonList
            } label: {
                Text("Scroll to...")
            }
        } else {
            seasonList
        }
    }
    
    var seasonList: some View {
        ForEach(1...show.numberOfSeasons, id: \.self) { season in
            Button {
                scrollToSection = season
            } label: {
                let seasonHeader: String = {
                    let seasonType = show.seasonType.rawValue.capitalized
                    var header = "\(seasonType) \(season)"
                    if let title = show.seasonTitles?[season] {
                        header += ": \(title)"
                    }
                    return header
                }()
                HStack {
                    Text(seasonHeader)
//                    Spacer()
//                    CircledNumber(number: episodeCount(season)) // circle and number are in different places...?
                }
            }
            .disabled(!availableSeasons.contains(season))
        }
    }
}

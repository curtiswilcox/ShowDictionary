//
//  SeasonView.swift
//  ShowDictionaryWatchOS Extension
//
//  Created by Curtis Wilcox on 1/4/20.
//  Copyright © 2020 wilcoxcurtis. All rights reserved.
//

import Foundation
import SwiftUI

struct SeasonView: View {
    let show: Show
    
    var body: some View {
        List(1...show.numberOfSeasons, id: \.self) { season in
            NavigationLink(destination: EpisodeChooserView(show: self.show, episodes: self.show.episodes.filter { $0.seasonNumber == season }, navTitle:  "\(self.show.typeOfSeasons.localizeCapSing) \(season)")) {
                VStack(alignment: .leading) {
                    Text("\(self.show.typeOfSeasons.localizeCapSing) \(season)")
                    SubText("episode".localizeWithFormat(quantity: self.show.episodes.filter { $0.seasonNumber == season }.count))
                }
            }
        }
        .navigationBarTitle(self.show.typeOfSeasons.localizeLowPlur.capitalized)
    }
}

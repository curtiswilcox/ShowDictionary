//
//  SeasonView.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 12/22/19.
//  Copyright © 2019 wilcoxcurtis. All rights reserved.
//

import SwiftUI

struct SeasonView: View {
    let show: Show
    
    var body: some View {
        List(1..<show.numberOfSeasons + 1) { season in
            NavigationLink(destination: EpisodeChooserView(navTitle: "\(String(format: NSLocalizedString("Episodes in %@", comment: ""), self.getTitle(self.show, season)))", show: self.show, episodes: self.show.episodes.filter { $0.seasonNumber == season } )) {
                VStack(alignment: .leading) {
                    Text(self.getTitle(self.show, season))
                    SubText("episode".localizeWithFormat(quantity: self.getNumEps(season)))
                }
            }
        }
        .navigationBarTitle(show.typeOfSeasons.localizeLowPlur.capitalized)
    }
    
    private func getTitle(_ show: Show, _ season: Int) -> String {
        let preColon = "\(self.show.typeOfSeasons.localizeCapSing) \(season)"
        if let title = show.seasonTitles?[season] {
            return "\(preColon): \(title)"
        }
        return preColon
    }
    
    private func getNumEps(_ season: Int) -> Int {
        return self.show.episodes!.reduce(0) { initial, episode in
            return episode.seasonNumber == season ? initial + 1 : initial
        }
    }
}

//struct SeasonView_Previews: PreviewProvider {
//    static var previews: some View {
//        SeasonView()
//    }
//}

//
//  EpisodeChooserView.swift
//  ShowDictionaryWatchOS Extension
//
//  Created by Curtis Wilcox on 1/4/20.
//  Copyright © 2020 wilcoxcurtis. All rights reserved.
//

import Foundation
import SwiftUI

struct EpisodeChooserView: View {
    let show: Show
    let episodes: [Episode]
    
    var body: some View {
        List {
            ForEach(self.getSeasons(), id: \.self) { season in
                Section(header: Text(getSeasonText(self.show, season))) {
                    ForEach(self.show.episodes.filter { $0.seasonNumber == season } ) { episode in
                        EpisodeRow(episode: episode)
                    }
                }
            }
        }
        .navigationBarTitle(NSLocalizedString("episodes", comment: "").capitalized)
    }
    
    private func getSeasons() -> [Int] {
        var seasons = [Int]()
        for season in 1...self.show.numberOfSeasons
            where !self.episodes.filter({ $0.seasonNumber == season }).isEmpty {
                seasons.append(season)
        }
        return seasons
    }
}

extension EpisodeChooserView {
    struct EpisodeRow: View {
        let episode: Episode
        
        var body: some View {
            VStack {
                HStack {
                    Text(episode.title)
                    Spacer()
                    Image(systemName: "star.fill")
                        .foregroundColor(episode.isFavorite ? .secondary : .clear)
                }
                HStack {
                    SubText("\(episode.code)")
                    Spacer()
                    SubText(episode.runtimeDescription() != nil ? episode.runtimeDescription()! : "")
                }
            }
            .padding([.top, .bottom], 5)
        }
    }
}

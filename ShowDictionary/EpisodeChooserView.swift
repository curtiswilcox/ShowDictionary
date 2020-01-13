//
//  EpisodeChooser.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 12/21/19.
//  Copyright © 2019 wilcoxcurtis. All rights reserved.
//

import SwiftUI

struct EpisodeChooserView: View {
    let navTitle: String
    let show: Show
    @State private(set) var episodes: [Episode] = []
    
    var body: some View {
        List {
            ForEach(self.getSeasons(), id: \.self) { season in
                Section(header: Text(getSeasonText(self.show, season))) {
                    ForEach(self.episodes.filter { $0.seasonNumber == season }) { episode in
                        NavigationLink(destination: EpisodeView(show: self.show, episode: episode)) {
                            EpisodeRow(show: self.show, episode: episode)
                        }
                    }
                }
            }
        }
        .navigationBarTitle(self.navTitle)
        .listStyle(GroupedListStyle())
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
        let show: Show
        @ObservedObject private(set) var episode: Episode
        
        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text(episode.title)
                    SubText(self.seasonNum(episode))
                    SubText(episode.airdate.written())
                }
                Spacer()
                Image(systemName: "star.fill")
                    .foregroundColor(episode.isFavorite ? .secondary : .clear)
                    .imageScale(.large)
            }
            .contextMenu {
                Button(action: self.toggleFavoritism) {
                    HStack {
                        Text(self.episode.isFavorite ? NSLocalizedString("Unfavorite", comment: "") : NSLocalizedString("Favorite", comment: ""))
                        Image(systemName: "star\(self.episode.isFavorite ? "" : ".fill")")
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        
        private func seasonNum(_ episode: Episode) -> String {
            let seasonType = self.show.typeOfSeasons.localizeCapSing
            let seasonNum = episode.seasonNumber
            let episodeNum = episode.numberInSeason
            
            return "\(seasonType) \(seasonNum), \(NSLocalizedString("Episode", comment: "subtitle (doesn't get a number preceding)")) \(episodeNum)"
        }
        
        private func toggleFavoritism() {
            self.episode.isFavorite.toggle()
            if self.episode.isFavorite {
                updateServerEpisodeIsFavorite(filename: self.show.filename, code: self.episode.code) {
                    self.episode.favoritedID = $0
                }
                self.show.hasFavoritedEpisodes = true
            } else {
                updateServerEpisodeIsNotFavorite(filename: self.show.filename, code: self.episode.code, id: self.episode.favoritedID!)
                self.episode.favoritedID = nil
//                for episode in self.show.episodes where !episode.isFavorite {
//                    self.show.hasFavoritedEpisodes = false
//                }
                self.show.hasFavoritedEpisodes = (self.show.episodes.filter { $0.isFavorite }.count != 0)
            }
        }
    }
}

//struct EpisodeChooser_Previews: PreviewProvider {
//    static var previews: some View {
//        EpisodeChooser()
//    }
//}

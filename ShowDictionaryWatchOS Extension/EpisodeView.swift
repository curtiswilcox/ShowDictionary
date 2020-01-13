//
//  EpisodeView.swift
//  ShowDictionaryWatchOS Extension
//
//  Created by Curtis Wilcox on 1/4/20.
//  Copyright © 2020 wilcoxcurtis. All rights reserved.
//

import Foundation
import SwiftUI

struct EpisodeView: View {
    let show: Show
    @ObservedObject private(set) var episode: Episode
    
    var body: some View {
        ScrollView {
            Text(episode.summary)
        }
        .navigationBarTitle(episode.title)
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
//            for episode in self.show.episodes where !episode.isFavorite {
//                self.show.hasFavoritedEpisodes = false
//            }
            self.show.hasFavoritedEpisodes = (self.show.episodes.filter { $0.isFavorite }.count != 0)
            
        }
    }
}

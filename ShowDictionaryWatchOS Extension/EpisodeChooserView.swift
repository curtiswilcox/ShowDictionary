/*
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
  @State private(set) var episodes: [Episode] = []
  let navTitle: String
  
  var body: some View {
    List {
      ForEach(self.getSeasons(), id: \.self) { season in
        Section(header: Text(getSeasonText(self.show, season))) {
          ForEach(self.episodes.filter { $0.seasonNumber == season } ) { episode in
            NavigationLink(destination: EpisodeView(show: self.show, episode: episode)) {
              EpisodeRow(episode: episode)
            }
          }
        }
      }
    }
    .navigationBarTitle(navTitle)
  }
  
  private func getSeasons() -> [Int] {
    var seasons = [Int]()
    for season in 1...self.show.numberOfSeasons where !self.episodes.filter({ $0.seasonNumber == season }).isEmpty {
      seasons.append(season)
    }
    return seasons
  }
}

extension EpisodeChooserView {
  struct EpisodeRow: View {
    @ObservedObject private(set) var episode: Episode
    
    var body: some View {
      VStack {
        HStack {
          Text(episode.title)
          Spacer()
          if episode.isFavorite {
            VStack {
              Image(systemName: "star.fill").foregroundColor(.secondary)
              Spacer()
            }
          }
        }
        HStack {
          SubText("\(episode.code)")
          Spacer()
          SubText(episode.runtimeDescription() ?? "")
        }
      }
      .padding([.top, .bottom], 5)
    }
  }
}
*/

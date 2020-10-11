//
//  Toolbar.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 1/14/20.
//  Copyright © 2020 wilcoxcurtis. All rights reserved.
//

import Network
import SwiftUI

struct Toolbar: View {
  @EnvironmentObject var show: Show
  @ObservedObject var episode: Episode
  
  var body: some View {
    HStack {
      Spacer()
      Button {
        self.episode.isFavorite.toggle()
        if self.episode.isFavorite {
          updateServerEpisodeIsFavorite(filename: self.show.filename, code: self.episode.code) {
            self.episode.favoritedID = $0
          }
          self.show.hasFavoritedEpisodes = true
        } else {
          updateServerEpisodeIsNotFavorite(filename: self.show.filename, code: self.episode.code, id: self.episode.favoritedID!)
          self.episode.favoritedID = nil
          self.show.hasFavoritedEpisodes = (self.show.episodes.filter { $0.isFavorite }.count != 0)
        }
      } label: {
        Image(systemName: "star\(episode.isFavorite ? ".fill" : "")")
          .imageScale(.large)
      }
      .disabled(NWPathMonitor().currentPath.status != .satisfied)
      .padding()
      
      NavigationLink(destination: EpisodeDetailView(episode: self.episode).environmentObject(show)) {
        Image(systemName: "info.circle")
          .imageScale(.large)
      }
      .padding()
    }
  }
}

//struct Toolbar_Previews: PreviewProvider {
//    static var previews: some View {
//        Toolbar()
//    }
//}

//
//  Toolbar.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 1/14/20.
//  Copyright © 2020 wilcoxcurtis. All rights reserved.
//

import SwiftUI

struct Toolbar: View {
    let show: Show
    @ObservedObject var episode: Episode
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
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
            }) {
                Image(systemName: "star\(episode.isFavorite ? ".fill" : "")")
                    .imageScale(.large)
            }
            .padding()
            
            NavigationLink(destination: EpisodeDetailView(show: self.show, episode: self.episode)) {
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

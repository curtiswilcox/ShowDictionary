//
//  EpisodeView.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 12/20/19.
//  Copyright © 2019 wilcoxcurtis. All rights reserved.
//

import Combine
import SwiftUI

struct EpisodeView: View {
    let show: Show
    @ObservedObject private(set) var episode: Episode
    
    var body: some View {
        ScrollView {
            HStack {
                Text(episode.summary)
                    .lineSpacing(10)
                    .padding(.all, 20)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .navigationBarTitle(episode.title)
            .navigationBarItems(trailing:
                HStack {
                    Button(action: {
                        self.episode.isFavorite.toggle()
                        if self.episode.isFavorite {
                            updateServerEpisodeIsFavorite(filename: self.show.filename, code: self.episode.code)
                            self.show.hasFavoritedEpisodes = true
                            
                        } else {
                            updateServerEpisodeIsNotFavorite(filename: self.show.filename, code: self.episode.code)
                            for episode in self.show.episodes where !episode.isFavorite {
                                self.show.hasFavoritedEpisodes = false
                            }
                        }
                    }) {
                        Image(systemName: "star\(episode.isFavorite ? ".fill" : "")")
                    }
                    Spacer()
                    Spacer()
                    NavigationLink(destination: EpisodeDetailView(show: self.show, episode: self.episode)) {
                        Image(systemName: "info.circle")
                    }
                }
            )
        }
    }
    
    init(show: Show) {
        self.show = show
        self.episode = show.episodes.randomElement()!
    }
    
    init(show: Show, episode: Episode) {
        self.show = show
        self.episode = episode
    }
}

//#if DEBUG
//struct EpisodeView_Previews: PreviewProvider {
//    static var previews: some View {
//        EpisodeView(show: Show(name: ""))
//    }
//}
//#endif

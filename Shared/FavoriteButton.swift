//
//  FavoriteButton.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 11/3/21.
//

import SwiftUI

struct FavoriteButton: View {
    @ObservedObject var observer: EpisodeObserver
    @Binding var show: Show
    @Binding var episode: Episode
    
    let toFavorite: String
    let toUnfavorite: String
    var tint: Color? = nil
    
    var body: some View {
        Button {
            episode.isFavorite.toggle()
            Task {
                do {
                    try await observer.toggleFavorite(isFavorite: episode.isFavorite, code: episode.code)
                    if episode.isFavorite {
                        show.hasFavoriteEpisodes = true
                    } else {
                        if observer.items.filter(\.isFavorite).isEmpty {
                            show.hasFavoriteEpisodes = false
                        }
                    }
                } catch let e {
                    episode.isFavorite.toggle()
                    print(e)
                }
            }
        } label: {
            if episode.isFavorite {
                Label("Unfavorite", systemImage: toUnfavorite)
            } else {
                Label("Favorite", systemImage: toFavorite)
            }
        }
        .tint(tint)
    }
}

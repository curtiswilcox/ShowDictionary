//
//  EpisodeView.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 10/28/21.
//

import SwiftUI

struct EpisodeView: View {
    @ObservedObject var observer: Observer<Episode>
    @Binding var show: Show
    @Binding var episode: Episode
    
    @State private var showDetails = false
    
    var body: some View {
        List {
            Section {
                Text(episode.summary)
            } header: {
                Text("Summary")
            }
            
            let seasonType = show.seasonType.rawValue.capitalized
            Section {
                let seasonEpisodeText: String = {
                    if let seasonTitle = show.seasonTitles?[episode.seasonNumber] {
                        return "\(seasonType) \(episode.seasonNumber): \(seasonTitle), Episode \(episode.episodeInSeason)"
                    } else {
                        return "\(seasonType) \(episode.seasonNumber), Episode \(episode.episodeInSeason)"
                    }
                }()
                Text(seasonEpisodeText)
            } header: {
                Text("\(seasonType) and Episode")
            }
            
            Section {
                Text("Episode \(episode.episodeInShow) of \(show.numberOfEpisodes)")
            } header: {
                Text("Number in show")
            }
            
            Section {
                Text(episode.airdate.written())
            } header: {
                Text("Original Airdate")
            }
            
            if let runtimeDesc = episode.runtimeDescription() {
                Section {
                    Text(runtimeDesc)
                } header: {
                    Text("Episode Length")
                }
            }
            
            if let writers = episode.writers?.map(\.description) {
                Section {
                    Text(writers.sentence)
                } header: {
                    Text("Written by")
                }
            }
            
            if let directors = episode.directors?.map(\.description) {
                Section {
                    Text(directors.sentence)
                } header: {
                    Text("Directed by")
                }
            }
            
            if let characters = show.characters?
                .filter({ $0.isIn(episode: episode) })
                .sorted() {
                Section {
                    ForEach(characters) { character in
                        Text("""
                            \(character.character.fullName) (portrayed by \(character.actor.fullName))
                            """)
                    }
                } header: {
                    Text("Characters in episode")
                }
            }
        }
        .navigationTitle(episode.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                FavoriteButton(observer: observer, episode: $episode)
//                Button {
//                    episode.isFavorite.toggle()
//                    do {
//                        try observer.toggleFavorite(to: episode.isFavorite, code: episode.code)
//                    } catch let e {
//                        episode.isFavorite.toggle()
//                        print(e)
//                    }
//                } label: {
//                    if episode.isFavorite {
//                        Label("Unfavorite", systemImage: "star.fill")
//                            .labelStyle(.iconOnly)
//                    } else {
//                        Label("Favorite", systemImage: "star")
//                            .labelStyle(.iconOnly)
//                    }
//                }
            }
        }
    }
}

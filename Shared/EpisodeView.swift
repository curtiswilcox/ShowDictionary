//
//  EpisodeView.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 10/28/21.
//

import SwiftUI

struct EpisodeView: View {
    @ObservedObject var observer: EpisodeObserver
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
            
            let seasonType = show.seasonType.localizedCapitalized
            let e = String(localized: "Episode")
            Section {
                let seasonEpisodeText: String = {
                    if let seasonTitle = show.seasonTitles?[episode.seasonNumber] {
                        return "\(seasonType) \(episode.seasonNumber): \(seasonTitle), \(e) \(episode.episodeInSeason)"
                    } else {
                        return "\(seasonType) \(episode.seasonNumber), \(e) \(episode.episodeInSeason)"
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
            
            if let writers = episode.writers {
                Section {
                    ForEach(writers) { writer in
                        Text(writer.fullName)
                    }
                } header: {
                    Text("Written by")
                }
            }
            
            if let directors = episode.directors {
                Section {
                    ForEach(directors) { director in
                        Text(director.fullName)
                    }
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
        .listStyle(.sidebar)
        .navigationTitle(episode.name)
        .toolbar {
            ToolbarItem {
                FavoriteButton(observer: observer, show: $show, episode: $episode, toFavorite: "star", toUnfavorite: "star.fill")
            }
        }
    }
}

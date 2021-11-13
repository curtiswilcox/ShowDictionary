//
//  AllEpisodeView.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 10/26/21.
//  Copyright © 2021 wilcoxcurtis. All rights reserved.
//

import SwiftUI

struct AllEpisodeView: View {
    @StateObject var observer = Observer<Episode>()
    @Binding var show: Show
            
    let filename: String
    
    @State private var loading = true
    
    @State private var searchText = ""
    @State private var showFavorites = false
    @State private var scrollToSection: Int?
    
    @State private var filters: (characters: [Portrayal]?, writers: [Person]?, directors: [Person]?) = (nil, nil, nil)
    
    var body: some View {
        let availableEpisodes = Binding(get: { calcAvailableEpisodes() }, set: { _ in })
        let availableSeasons = Set(availableEpisodes.wrappedValue.map(\.wrappedValue.seasonNumber)).sorted()
        let hasFavorites = availableEpisodes.wrappedValue.map(\.wrappedValue.isFavorite).contains(true)
        
        let characters = Binding(get: {
            show.characters?.reduce(into: [Portrayal: (count: Int, valid: Bool)]()) { (result, entry) in
                let availableAppearances = entry.appearances
                    .filter {
                        availableEpisodes
                            .wrappedValue
                            .map(\.wrappedValue.code)
                            .contains($0)
                    }
                result[entry] = (count: availableAppearances.count, valid: !availableAppearances.isEmpty)
            }
        }, set: { _ in })
        
        let directors = Binding(get: {
            observer.items.validityReduction(for: \.directors, episodes: availableEpisodes)
        }, set: { _ in })

        let writers = Binding(get: {
            observer.items.validityReduction(for: \.writers, episodes: availableEpisodes)
        }, set: { _ in })
        
        return LoaderView(observer: observer, loading: $loading) {
            ScrollViewReader { proxy in
                List {
                    Section {
                        Text(show.summary)
                            .lineSpacing(1.5)
                    } header: {
                        Text("Description")
                    }
                    
                    ForEach(availableSeasons, id: \.self) { seasonNumber in
                        Section {
                            ForEach(availableEpisodes.wrappedValue.filter { $episode in
                                episode.seasonNumber == seasonNumber
                            }) { $episode in
                                NavigationLink {
                                    EpisodeView(observer: observer, show: $show, episode: $episode)
                                } label: {
                                    Label {
                                        HStack(alignment: .top) {
                                            Text(episode.name)
                                            Spacer()
                                            if episode.isFavorite {
                                                Image(systemName: "star")
                                                    .symbolVariant(.fill)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                    } icon: {
                                        CircledNumber(number: episode.episodeInSeason, force: true)
                                            .imageScale(.large)
                                            .foregroundColor(.primary)
                                    }
                                }
                                .swipeActions(edge: .trailing) {
                                    FavoriteButton(observer: observer, episode: $episode, toFavorite: "star", toUnfavorite: "star.slash", tint: .blue)
                                }
                            }
                        } header: {
                            let seasonType = show.seasonType.localizedCapitalized
                            let seasonTitle = show.seasonTitles?[seasonNumber]
                            
                            Text("\(seasonType) \(seasonNumber)\(seasonTitle != nil ? ": \(seasonTitle!)" : "")")
                        }
                    }
                }
                .listStyle(.sidebar)
                .searchable(text: $searchText.animation())
                .onChange(of: scrollToSection) { section in
                    guard let section = section else { return }
                    withAnimation(.easeInOut(duration: 2)) {
                        proxy.scrollTo(section, anchor: .top)
                    }
                    scrollToSection = nil
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Picker("", selection: $showFavorites.animation()) {
                    Text("All").tag(false)
                    Text("Favorites").tag(true)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .disabled(!hasFavorites)
            }
            
            ToolbarItem(placement: .automatic) {
                Menu {
                    Section {
                        let episodeCount: (Int) -> Int = { (season) in
                            observer.items.filter { episode in
                                episode.seasonNumber == season
                            }
                            .count
                        }
                        SeasonScrollMenu(show: $show, availableSeasons: availableSeasons, scrollToSection: $scrollToSection, includeOuterMenu: !(characters.wrappedValue == nil && directors.wrappedValue?.isEmpty ?? true && writers.wrappedValue?.isEmpty ?? true), episodeCount: episodeCount)
                    }

                    if characters.wrappedValue != nil || !(directors.wrappedValue?.isEmpty ?? true) || !(writers.wrappedValue?.isEmpty ?? true) {
                        Section {
                            
                            if characters.wrappedValue != nil {
                                FilterMenu(people: characters, type: String(localized: "character"), current: $filters.characters)
                            }
                                                        
                            if !(directors.wrappedValue?.isEmpty ?? true) {
                                FilterMenu(people: directors, type: String(localized: "director"), current: $filters.directors)
                            }

                            if !(writers.wrappedValue?.isEmpty ?? true) {
                                FilterMenu(people: writers, type: String(localized: "writer"), current: $filters.writers)
                            }
                        }
                        
                        Section {
                            Button(role: .destructive) {
                                withAnimation {
                                    filters = (nil, nil, nil)
                                }
                            } label: {
                                Text("Clear active filters")
                            }
                            .disabled(filters == (nil, nil, nil))
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .symbolVariant(.circle)
                }
                .disabled(loading)
            }
        }
        .navigationTitle("\(show.name) Episodes")
        .onAppear {
            if observer.file == nil {
                observer.update(file: filename)
            }
        }
    }
    
    private func calcAvailableEpisodes() -> [Binding<Episode>] {
        $observer.items.filter { $episode in
            if showFavorites && !episode.isFavorite {
                return false
            }
            
            if let characters = filters.characters,
               !characters.allSatisfy({ $0.appearances.contains(episode.code) }) {
                return false
            }
            
            if let directors = filters.directors,
               let epDirectors = episode.directors {
                for director in directors {
                    if !epDirectors.contains(director) {
                        return false
                    }
                }
            }
            
            if let writers = filters.writers,
               let epWriters = episode.writers {
                for writer in writers {
                    if !epWriters.contains(writer) {
                        return false
                    }
                }
            }
            
            return episode.matchesSearchText(searchText)
        }
    }            
}

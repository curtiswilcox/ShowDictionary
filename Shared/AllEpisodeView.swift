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
    let language: String
    
    @State private var loading = true
    
    @State private var searchText = ""
    @State private var showFavorites = false
    @State private var scrollToSection: Int?
    
    @State private var filters: (character: Portrayal?, writer: Person?, director: Person?) = (nil, nil, nil)
    
    var body: some View {
        let availableEpisodes = calcAvailableEpisodes()
        let availableSeasons = Set(availableEpisodes.map(\.wrappedValue.seasonNumber)).sorted()
        let hasFavorites = availableEpisodes.map(\.wrappedValue.isFavorite).contains(true)
        
        return LoaderView(observer: observer, loading: $loading) {
            ScrollViewReader { proxy in
                List(availableSeasons, id: \.self) { seasonNumber in
                    Section(header: header(seasonNumber)) {
                        ForEach(availableEpisodes.filter { $episode in
                            episode.seasonNumber == seasonNumber
                        }) { $episode in
                            DisclosureGroup {
                                EpisodeView(observer: observer, show: $show, episode: $episode)
                            } label: {
                                Label {
                                    Text(episode.name)
                                } icon: {
                                    CircledNumber(number: episode.episodeInSeason, force: true)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    }
                }
                .listStyle(.sidebar)
                .if(!availableEpisodes.isEmpty) { view in
                    view.searchable(text: $searchText)
                }
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
            
            ToolbarItem(placement: .navigationBarTrailing) {
                let characters = show.characters
                let writers = observer.items.compactMap(\.writers).flatMap({$0}).reduce(into: [Person: Int]()) { result, entry in
                    if result[entry] != nil {
                        result[entry]! += 1
                    } else {
                        result[entry] = 1
                    }
                }
                let directors = observer.items.compactMap(\.directors).flatMap({$0}).reduce(into: [Person: Int]()) { result, entry in
                    if result[entry] != nil {
                        result[entry]! += 1
                    } else {
                        result[entry] = 1
                    }
                }
                
                Menu {
                    Section {
                        let episodeCount: (Int) -> Int = { (season) in
                            observer.items.filter { episode in
                                episode.seasonNumber == season
                            }
                            .count
                        }
                        SeasonScrollMenu(show: $show, availableSeasons: availableSeasons, scrollToSection: $scrollToSection, includeOuterMenu: !(characters == nil && writers.isEmpty && directors.isEmpty), episodeCount: episodeCount)
                    }
                    
                    if characters != nil || !writers.isEmpty || !directors.isEmpty {
                        Section {
                            if let characters = characters {
                                CharacterMenu(characters: characters, current: $filters.character)
                            }
                            
                            if !directors.isEmpty {
                                CrewMemberMenu(people: directors, type: "director", current: $filters.director)
                            }
                            
                            if !writers.isEmpty {
                                CrewMemberMenu(people: writers, type: "writer", current: $filters.writer)
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
            if observer.file == nil || observer.language == nil {
                observer.update(file: filename, language: language)
            }
        }
    }
    
    private func calcAvailableEpisodes() -> [Binding<Episode>] {
        $observer.items.filter { $episode in
            if showFavorites && !episode.isFavorite {
                return false
            }
            
            if let character = filters.character, !character.appearances.contains(episode.code) {
                return false
            }
            
            if let writer = filters.writer, !(episode.writers?.contains(writer) ?? false) {
                return false
            }
            
            if let director = filters.director, !(episode.directors?.contains(director) ?? false) {
                return false
            }
            
            return episode.matchesSearchText(searchText)
        }
    }
    
    private func header(_ seasonNumber: Int) -> some View {
        let seasonType = show.seasonType.rawValue.capitalized
        let seasonTitle = show.seasonTitles?[seasonNumber]
        
        return Text("    \(seasonType) \(seasonNumber)\(seasonTitle != nil ? ": \(seasonTitle!)" : "")")
            .textCase(.uppercase)
            .font(.caption)
            .foregroundColor(.gray)
            .padding(.top)
            .padding(.bottom, 5)
    }
        
    private struct CrewMemberMenu: View {
        let people: [Person: Int]
        let type: String
        
        @Binding var current: Person?
        
        var body: some View {
            Menu {
                Section {
                    Button {
                        withAnimation {
                            current = nil
                        }
                    } label: {
                        Text("Clear \(type) filter (\(current != nil ? current!.fullName : "no active filter"))")
                    }
                    .disabled(current == nil)
                }
                
                ForEach(people.keys.sorted()) { person in
                    Button {
                        withAnimation {
                            current = person
                        }
                    } label: {
                        Text(person.description)
                        Spacer()
                        if let count = people[person] {
                            CircledNumber(number: count, force: false)
                                .foregroundColor(.primary)
                        }
                    }
                    .disabled(current == person)
                }
            } label: {
                Label("Filter by \(type)", systemImage: "checkmark")
                    .if(current == nil) {
                        $0.labelStyle(.titleOnly)
                    } else: {
                        $0.labelStyle(.titleAndIcon)
                    }
            }
        }
    }
    
    private struct CharacterMenu: View {
        let characters: [Portrayal]
        @Binding var current: Portrayal?
        
        var body: some View {
            Menu {
                Section {
                    Button {
                        withAnimation {
                            current = nil
                        }
                    } label: {
                        Text("Clear character filter (\(current != nil ? current!.character.fullName : "no active filter"))")
                    }
                    .disabled(current == nil)
                }
                
                ForEach(characters.sorted()) { character in
                    Button {
                        withAnimation {
                            current = character
                        }
                    } label: {
                        Text(character.attributed)
                    }
                    .disabled(current == character)
                }
            } label: {
                Text("Filter by character")
            }
        }
    }
}

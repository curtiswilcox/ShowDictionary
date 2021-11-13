//
//  ContentView.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 10/25/21.
//  Copyright © 2021 wilcoxcurtis. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @StateObject var observer = Observer<Show>(file: "shows")
    
    @State private var loading = false
    
    @State private var searchText = ""
    @State private var scrollToSection: String?
    
    private let columns = 3
    
    var body: some View {
        let availableShows = $observer.items.filter { $show in
            show.matchesSearchText(searchText)
        }
        let sections = Set(availableShows.map { $0.wrappedValue.sortName.firstLetter().withoutDiacritics() }).sorted()
        
        return NavigationView {
            ScrollViewReader { proxy in
                LoaderView(observer: observer, loading: $loading) {
                    List {
                        ForEach(sections, id: \.self) { section in
                            Section {
                                ForEach(availableShows.filter({ $show in
                                    show.sortName.firstLetter().withoutDiacritics() == section
                                })) { $show in
                                    NavigationLink(destination: AllEpisodeView(show: $show, filename: show.filename)) {
                                        TitleCardView(show: $show)
                                        VStack(alignment: .leading) {
                                            Text(show.name)
                                                .font(.headline)
                                            Spacer()
                                            Text("number of \(show.seasonType.rawValue)".localizeWithFormat(quantity: show.numberOfSeasons)).subtext()
                                            Text("episodes".localizeWithFormat(quantity: show.numberOfEpisodes)).subtext()
                                        }
                                        .padding([.leading, .vertical])
                                    }
                                }
                            } header: {
                                Text(section)
                            }
                        }
                    }
//                    .padding(.trailing)
                    .onChange(of: scrollToSection) { section in
                        guard let section = section else { return }
                        withAnimation(.easeInOut(duration: 2)) {
                            proxy.scrollTo(section, anchor: .top)
                        }
                        scrollToSection = nil
                    }
                }
//                .overlay(sectionIndices(scrollProxy: proxy, sections: sections))
            }
            .searchable(text: $searchText.animation())
            .navigationTitle("Home")
#if os(macOS)
            .navigationViewStyle(.columns)
#endif
            .toolbar {
                ToolbarItem {
                    let showCount: (String) -> Int = { (section) in
                        availableShows.filter({ $show in
                            show.sortName.alphanumeric().firstLetter().localizedLowercase == section.localizedLowercase
                        }).count
                    }
                    SectionScrollMenu(showCount: showCount, sections: sections, scrollToSection: $scrollToSection)
                        .disabled(loading)
                }
            }
        }
    }
    /*
    func sectionIndices(scrollProxy: ScrollViewProxy, sections: [String]) -> some View {
        SectionIndexView(scrollProxy: scrollProxy, titles: sections)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding()
    }
    */
    private struct SectionScrollMenu: View {
        let showCount: (String) -> Int
        let sections: [String]
        @Binding var scrollToSection: String?

        var body: some View {
            Menu {
                ForEach(sections, id: \.self) { section in
                    Button {
                        scrollToSection = section
                    } label: {
                        Label("Scroll to shows that start with \(section.localizedUppercase)", systemImage: "\(section.lowercased())").symbolVariant(.circle)
                    }
                }
            } label: {
                Image(systemName: "ellipsis")
                    .symbolVariant(.circle)
            }
        }
    }
}

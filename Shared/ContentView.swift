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
        let sections = Set(availableShows.map { $0.wrappedValue.sortName.firstLetter() }).sorted()
        let enumeratedSections = Array(zip(sections.indices, sections))
        
        return NavigationView {
            LoaderView(observer: observer, loading: $loading) {
                GeometryReader { geometry in
                    let width = geometry.size.width
                    ScrollViewReader { proxy in
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: columns)) {
                            ForEach(enumeratedSections, id: \.1) { idx, section in
                                Section {
                                    ForEach(availableShows.filter({ $show in
                                        show.sortName.firstLetter() == section
                                    })) { $show in
                                        NavigationLink(destination: AllEpisodeView(show: $show, filename: show.filename, language: "en")) {
                                            TitleCardView(show: $show, width: width, columns: CGFloat(columns))
                                        }
                                        .buttonStyle(.plain)
                                    }
                                } header: {
                                    HStack {
                                        Text(section)
                                            .font(.title)
                                            .bold()
                                            .if(idx != 0) { view in
                                                view.padding(.top)
                                            }
                                        Spacer()
                                    }
                                    .padding(.leading)
                                } footer: {
                                    let last = enumeratedSections[enumeratedSections.count - 1].0
                                    if idx != last {
                                        AnyView(Divider())
                                    } else {
                                        AnyView(EmptyView())
                                    }
                                }
                            }
                        }
                        .padding([.top, .horizontal])
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
            }
            .navigationTitle("Home")
            #if os(macOS)
            .navigationViewStyle(.columns)
            #endif
            .searchable(text: $searchText.animation())
            .toolbar {
                ToolbarItem {
                    let showCount: (String) -> Int = { (section) in
                        availableShows.filter({ $show in
                            show.sortName.alphanumeric().firstLetter().lowercased() == section.lowercased()
                        }).count
                    }
                    SectionScrollMenu(showCount: showCount, sections: sections, scrollToSection: $scrollToSection)
                        .disabled(loading)
                }
            }
        }
    }
    
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
                        Label {
                            Text("Scroll to shows that start with \(section.uppercased())")
                        } icon: {
                            Image(systemName: "\(showCount(section)).circle")
                        }
                    }
                }
            } label: {
                Image(systemName: "ellipsis")
                    .symbolVariant(.circle)
            }
        }
    }
}

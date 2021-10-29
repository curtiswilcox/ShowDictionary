//
//  ContentView.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 10/25/21.
//  Copyright © 2021 wilcoxcurtis. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @StateObject var observer = Observer<Show>(file: "shows", language: "en")
    
    @State var searchText = ""
    
    private let columns = 3
    
    var body: some View {
        NavigationView {
            LoaderView(observer: observer) {
                GeometryReader { geometry in
                    let width = geometry.size.width
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: columns)) {
                            ForEach($observer.items.filter({ $show in
                                show.matchesSearchText(searchText)
                            })) { $show in
                                NavigationLink(destination: AllEpisodeView(show: $show, filename: show.filename, language: "en")) {
                                    TitleCardView(show: $show, width: width, columns: CGFloat(columns))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding([.top, .horizontal])
                    }
                }
            }
            .navigationTitle("Home")
            .searchable(text: $searchText)
        }
    }
}

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
    
    @State private var searchText = ""
    
    var body: some View {
        LoaderView(observer: observer) {
            List($observer.items.filter { $episode in
                searchText.isEmpty || episode.validItem(searchText: searchText)
            }) { $episode in
                Section {
                    VStack {
                        HStack {
                            Text("\(episode.code)")
                                .subtext()
                            Spacer()
                            Text("#\(episode.episodeInShow)")
                                .subtext()
                        }
                        Text(episode.name)
                            .font(.title)
                            .multilineTextAlignment(.center)
                        Text(episode.writer)
                            .multilineTextAlignment(.center)
                        Spacer()
                        Text(episode.summary)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
        }
        .navigationTitle("\(show.name) Episodes")
        .onAppear {
            if observer.file == nil || observer.language == nil {
                observer.update(file: filename, language: language)
            }
        }
    }
}

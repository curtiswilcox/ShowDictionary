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
        Text(episode.summary)
            .font(.callout)
            .multilineTextAlignment(.leading)
            .lineLimit(nil)
            .listRowSeparator(.hidden, edges: .bottom)
            .padding(.leading)
        
        HStack {
            Text(episode.airdate.written())
                .subtext()
            Spacer()
            
            if let runtimeDesc = episode.runtimeDescription() {
                Text(runtimeDesc)
                    .subtext()
            }

            Spacer()
            
            Button {
                episode.isFavorite.toggle()
                do {
                    try observer.toggleFavorite(to: episode.isFavorite, code: episode.code)
                } catch let e {
                    episode.isFavorite.toggle()
                    print(e)
                }
            } label: {
                Image(systemName: episode.isFavorite ? "star.fill" : "star")
            }
            .buttonStyle(.borderless)
            .tint(.blue)
        }
        .padding(.leading)
    }
}

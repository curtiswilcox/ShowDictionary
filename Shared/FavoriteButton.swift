//
//  FavoriteButton.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 11/3/21.
//

import SwiftUI

struct FavoriteButton: View {
    @ObservedObject var observer: Observer<Episode>
    @Binding var episode: Episode
    
    var body: some View {
        Button {
            episode.isFavorite.toggle()
            do {
                try observer.toggleFavorite(to: episode.isFavorite, code: episode.code)
            } catch let e {
                episode.isFavorite.toggle()
                print(e)
            }
        } label: {
            Label("\(episode.isFavorite ? "Unf" : "F")avorite", systemImage: episode.isFavorite ? "star.fill" : "star")
                .labelStyle(.iconOnly)
        }
        .buttonStyle(.borderless)
    }
}

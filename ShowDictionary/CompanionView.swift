//
//  CompanionView.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 12/23/19.
//  Copyright © 2019 wilcoxcurtis. All rights reserved.
//

import SwiftUI

struct CompanionView: View {
    let show: Show
    
    var body: some View {
        List(getCompanions(), id: \.self) { companion in
            NavigationLink(destination: EpisodeChooserView(navTitle: "\(String(format: NSLocalizedString("Episodes with %@", comment: ""), companion))", show: self.show, episodes: self.show.episodes.filter { $0.companions!.contains(companion) })) {
                VStack(alignment: .leading) {
                    Text(companion)
                    SubText("episode".localizeWithFormat(quantity: self.getNumEps(companion)))
                }
            }
        }
        .navigationBarTitle("companion".localizeWithFormat(quantity: 2).capitalized)
    }
    
    private func getCompanions() -> [String] {
        let companions = show.episodes!.map { $0.companions! }.reduce([], +)
        return Set<String>(companions).sorted()
    }
    
    private func getActor(_ companion: String) -> String {
        for character in show.characters ?? [] {
            if character.character == companion {
                return character.actor
            }
        }
        return ""
    }
    
    private func getNumEps(_ companion: String) -> Int {
        return show.episodes.filter { $0.companions!.contains(companion) }.count
    }
}

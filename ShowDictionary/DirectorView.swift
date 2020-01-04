//
//  DirectorView.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 12/23/19.
//  Copyright © 2019 wilcoxcurtis. All rights reserved.
//

import SwiftUI

struct DirectorView: View {
    var show: Show
    
    var body: some View {
        List(getDirectors(), id: \.self) { director in
            NavigationLink(destination: EpisodeChooserView(navTitle: "\(String(format: NSLocalizedString("Episodes directed by %@", comment: ""), director))", show: self.show, episodes: self.show.episodes.filter { $0.director == director })) {
                VStack(alignment: .leading) {
                    Text(director)
                    SubText("episode".localizeWithFormat(quantity: self.getNumEps(director)))
                }
            }
        }
        .navigationBarTitle("director".localizeWithFormat(quantity: 2).capitalized)
    }
    
    private func getDirectors() -> [String] {
        let directors = show.episodes!.map { $0.director! }
        return Set<String>(directors).sorted()
    }
    
    private func getNumEps(_ director: String) -> Int {
        return show.episodes.filter { $0.director! == director }.count
    }
}

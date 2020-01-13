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
        List {
            ForEach(self.getSectionHeaders(), id: \.self) { header in
                Section(header: Text(header)) {
                    ForEach(self.getDirectors().filter { $0.lastName.first!.uppercased() == header }) { director in
                        DirectorRow(show: self.show, director: director)
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("director".localizeWithFormat(quantity: getDirectors().count).capitalized)
    }
    
    private func getSectionHeaders() -> [String] {
        return Set(getDirectors().map { $0.lastName.first!.uppercased() }).sorted()
    }
    
    private func getDirectors() -> [Person] {
        var directors = [Person]()
        for episode in self.show.episodes {
            for director in episode.directors! {
                directors.append(director)
            }
        }
        return Set(directors).sorted()
    }
}


extension DirectorView {
    struct DirectorRow: View {
        let show: Show
        let director: Person
        
        var body: some View {
            NavigationLink(destination: EpisodeChooserView(navTitle: "\(String(format: NSLocalizedString("Episodes directed by %@", comment: ""), director.fullName))", show: self.show, episodes: self.show.episodes.filter { episode in episode.directors!.contains(director) })) {
                VStack(alignment: .leading) {
                    Text(director.fullName)
                    SubText("episode".localizeWithFormat(quantity: self.getNumEps(director)))
                }
            }
        }
        
        private func getNumEps(_ director: Person) -> Int {
            return show.episodes.filter { $0.directors!.contains(director) }.count
        }
    }
}

//
//  WriterView.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 12/23/19.
//  Copyright © 2019 wilcoxcurtis. All rights reserved.
//

import SwiftUI

struct WriterView: View {
    var show: Show
    
    var body: some View {
        List {
            ForEach(self.getSectionHeaders(), id: \.self) { header in
                Section(header: Text(header)) {
                    ForEach(self.getWriters().filter { $0.lastName.first!.uppercased() == header }) { writer in
                        WriterRow(show: self.show, writer: writer)
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("writer".localizeWithFormat(quantity: getWriters().count).capitalized)
    }
    
    private func getSectionHeaders() -> [String] {
        return Set(getWriters().map { $0.lastName.first!.uppercased() }).sorted()
    }
    
    private func getWriters() -> [Person] {
        var writers = [Person]()
        for episode in self.show.episodes {
            for writer in episode.writers! {
                writers.append(writer)
            }
        }
        return Set(writers).sorted()
    }
}


extension WriterView {
    struct WriterRow: View {
        let show: Show
        let writer: Person
        
        var body: some View {
            NavigationLink(destination: EpisodeChooserView(navTitle: "\(String(format: NSLocalizedString("Episodes directed by %@", comment: ""), writer.fullName))", show: self.show, episodes: self.show.episodes.filter { episode in episode.writers!.contains(writer) })) {
                VStack(alignment: .leading) {
                    Text(writer.fullName)
                    SubText("episode".localizeWithFormat(quantity: self.getNumEps(writer)))
                }
            }
        }
        
        private func getNumEps(_ writer: Person) -> Int {
            return show.episodes.filter { $0.writers!.contains(writer) }.count
        }
    }
}

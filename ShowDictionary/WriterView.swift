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
        List(getWriters(), id: \.self) { writer in
            NavigationLink(destination: EpisodeChooserView(navTitle: "\(String(format: NSLocalizedString("Episodes written by %@", comment: ""), writer))", show: self.show, episodes: self.show.episodes.filter { $0.writer == writer })) {
                VStack(alignment: .leading) {
                    Text(writer)
                    SubText("episode".localizeWithFormat(quantity: self.getNumEps(writer)))
                }
            }
        }
        .navigationBarTitle("writer".localizeWithFormat(quantity: 2).capitalized)
    }
    
    private func getWriters() -> [String] {
        let writers = show.episodes!.map { $0.writer! }
        return Set<String>(writers).sorted()
    }
    
    private func getNumEps(_ writer: String) -> Int {
        return self.show.episodes.filter { $0.writer! == writer }.count
    }
}

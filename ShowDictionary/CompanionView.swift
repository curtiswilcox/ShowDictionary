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
    List {
      ForEach(self.getSectionHeaders(), id: \.self) { header in
        Section(header: Text(header)) {
          ForEach(self.getCompanions().filter { $0.lastName.firstLetter() == header }, id: \.self) { companion in
            NavigationLink(destination: EpisodeChooserView(navTitle: "\(String(format: NSLocalizedString("Episodes with %@", comment: ""), companion.fullName))", show: self.show, episodes: self.show.episodes.filter { $0.companions!.contains(companion) })) {
              VStack(alignment: .leading) {
                Text(companion.fullName)
                SubText("episode".localizeWithFormat(quantity: self.getNumEps(companion)))
              }
            }
          }
        }
      }
    }
    .navigationBarTitle("companion".localizeWithFormat(quantity: 2).capitalized)
  }
  
  private func getSectionHeaders() -> [String] {
    return Set(getCompanions().map { $0.lastName.firstLetter().uppercased() }).sorted()
  }
  
  private func getCompanions() -> [Person] {
    let companions = show.episodes!.map { $0.companions! }.reduce([], +)
    return Set<Person>(companions).sorted()
  }
  
  private func getNumEps(_ companion: Person) -> Int {
    return show.episodes.filter { $0.companions!.contains(companion) }.count
  }
}

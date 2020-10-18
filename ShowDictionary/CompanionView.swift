//
//  CompanionView.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 12/23/19.
//  Copyright © 2019 wilcoxcurtis. All rights reserved.
//

import SwiftUI

struct CompanionView: View {
  @EnvironmentObject var show: Show
  @State var companionSelected: (companion: Person?, showing: Bool) = (nil, false)
  
  var body: some View {
    ZStack {
      if let companion = companionSelected.companion {
        let navTitle = String(format: NSLocalizedString("%@", comment: ""), companion.fullName)
        let episodesToPass = self.show.episodes.filter { $0.companions!.contains(companion) }
        NavigationLink(destination: EpisodeChooserView(navTitle: navTitle, useSections: true, episodes: episodesToPass).environmentObject(show), isActive: $companionSelected.showing) {
          EmptyView()
        }
      }
      GridView(companionSelected: $companionSelected)
    }
    .navigationBarTitle("companion".localizeWithFormat(quantity: 2).capitalized)
  }
}

extension CompanionView {
  struct GridView: View {
    @EnvironmentObject var show: Show
    @Binding var companionSelected: (companion: Person?, showing: Bool)
    
    var body: some View {
      GeometryReader { geometry in
        ScrollView {
          LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 20) {
            ForEach(getSectionHeaders(show: show), id: \.self) { header in
              Section(header: SectionHeaderView<Text>(width: geometry.size.width) { Text(header) }) {
                ForEach(getCompanions(show: show, header: header), id: \.self) { companion in
                  Button {
                    companionSelected = (companion, true)
                  } label: {
                    let width = geometry.size.width / 2.5
                    CardView(width: width, vertAlignment: .top, horizAlignment: .leading) {
                      Text(companion.fullName)
                        .font(.callout)
                        .bold()
                        .foregroundColor(Color(UIColor.label))
                        .padding(.top)
                      if let actor = show.characters?.first(where: { $0.character == companion })?.actor {
                        SubText(actor.fullName)
                      }
                      Spacer()
                      Divider()
                        .background(Color.gray)
                        .frame(width: width / 3)
                        .padding(.all, 0)
                      SubText("episode".localizeWithFormat(quantity: getNumEps(show: show, companion: companion)))
                        .padding(.bottom)
                    }
                  }
                }
              }
            }
          }
          .padding(.horizontal)
        }
        .onAppear { companionSelected = (nil, false) }
      }
    }
  }
}

fileprivate func getCompanions(show: Show, header: String? = nil) -> [Person] {
  let companions = show.episodes!.map { $0.companions! }.reduce([], +)
  if let header = header {
    return Set<Person>(companions).filter { $0.lastName.firstLetter().uppercased() == header.uppercased() }.sorted()
  }
  return Set<Person>(companions).sorted()
}

fileprivate func getNumEps(show: Show, companion: Person) -> Int {
  return show.episodes.filter { $0.companions!.contains(companion) }.count
}

fileprivate func getSectionHeaders(show: Show) -> [String] {
  return Set(getCompanions(show: show).map { $0.lastName.firstLetter().uppercased() }).sorted()
}

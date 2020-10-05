//
//  SeasonView.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 12/22/19.
//  Copyright © 2019 wilcoxcurtis. All rights reserved.
//

import SwiftUI

struct SeasonView: View {
  @State var seasonSelected: (season: Int?, showing: Bool) = (nil, false)
  let show: Show
  
  var body: some View {
    ZStack {
      if let season = seasonSelected.season {
        let title = self.getTitle(self.show, season)
        let navTitle = "\(String(format: NSLocalizedString("Episodes in %@", comment: ""), title))"
        
        NavigationLink(destination: EpisodeChooserView(navTitle: navTitle, show: self.show, episodes: self.show.episodes.filter { $0.seasonNumber == season }), isActive: $seasonSelected.showing) {
          EmptyView()
        }
      }
      GeometryReader { geometry in
        ScrollView {
          LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 20) {
            ForEach(1..<show.numberOfSeasons + 1) { season in
              Button {
                seasonSelected = (season, true)
              } label: {
                let width = geometry.size.width / 2.5
                CardView(width: width, horizAlignment: .leading) {
                  Text(self.getTitle(self.show, season))
                    .font(.callout)
                    .bold()
                    .foregroundColor(Color(UIColor.label))
                    .padding(.top)
                  Spacer()
                  Divider()
                    .background(Color(UIColor.systemGray))
                    .frame(width: width / 3)
                    .padding(.all, 0)
                  SubText("episode".localizeWithFormat(quantity: self.getNumEps(season)))
                    .padding(.bottom)
                }
              }
            }
          }
          .padding(.horizontal)
        }
        .onAppear { seasonSelected = (nil, false) }
      }
    }
    .navigationBarTitle(show.typeOfSeasons.localizeLowPlur.capitalized)
  }
  
//  var body: some View {
//    List(1..<show.numberOfSeasons + 1) { season in
//      NavigationLink(destination: EpisodeChooserView(navTitle: "\(String(format: NSLocalizedString("Episodes in %@", comment: ""), self.getTitle(self.show, season)))", show: self.show, episodes: self.show.episodes.filter { $0.seasonNumber == season } )) {
//        VStack(alignment: .leading) {
//          Text(self.getTitle(self.show, season))
//          SubText("episode".localizeWithFormat(quantity: self.getNumEps(season)))
//        }
//      }
//    }
//    .navigationBarTitle(show.typeOfSeasons.localizeLowPlur.capitalized)
//  }
  
  private func getTitle(_ show: Show, _ season: Int) -> String {
    let preColon = "\(self.show.typeOfSeasons.localizeCapSing) \(season)"
    if let title = show.seasonTitles?[season] {
      return "\(preColon): \(title)"
    }
    return preColon
  }
  
  private func getNumEps(_ season: Int) -> Int {
    return self.show.episodes!.reduce(0) { initial, episode in
      return episode.seasonNumber == season ? initial + 1 : initial
    }
  }
}

//struct SeasonView_Previews: PreviewProvider {
//    static var previews: some View {
//        SeasonView()
//    }
//}

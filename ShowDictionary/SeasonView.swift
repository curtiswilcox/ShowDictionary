//
//  SeasonView.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 12/22/19.
//  Copyright © 2019 wilcoxcurtis. All rights reserved.
//

import SwiftUI

struct SeasonView: View {
  @EnvironmentObject var show: Show
  @State var seasonSelected: (season: Int?, showing: Bool) = (nil, false)

  var body: some View {
    ZStack {
      if let season = seasonSelected.season {
        let title = getTitle(self.show, season)
//        let navTitle = "\(String(format: NSLocalizedString("Episodes in %@", comment: ""), title))"
        let navTitle = String(format: NSLocalizedString("%@", comment: ""), title)
        let episodesToPass = self.show.episodes.filter { $0.seasonNumber == season }
        NavigationLink(destination: EpisodeChooserView(navTitle: navTitle, useSections: false, episodes: episodesToPass).environmentObject(show), isActive: $seasonSelected.showing) {
          EmptyView()
        }
      }
      GridView(seasonSelected: $seasonSelected)
    }
    .navigationBarTitle(show.typeOfSeasons.localizeLowPlur.capitalized)
  }
}

extension SeasonView {
  struct GridView: View {
    @EnvironmentObject var show: Show
    @Binding var seasonSelected: (season: Int?, showing: Bool)
    
    var body: some View {
      GeometryReader { geometry in
        ScrollView {
          LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 20) {
            ForEach(1..<show.numberOfSeasons + 1) { season in
              Button {
                seasonSelected = (season, true)
              } label: {
                let width = geometry.size.width / 2.5
                CardView(width: width, horizAlignment: .leading) {
                  Text(getTitle(self.show, season))
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
    
    private func getNumEps(_ season: Int) -> Int {
      return self.show.episodes!.reduce(0) { initial, episode in
        return episode.seasonNumber == season ? initial + 1 : initial
      }
    }
  }
}

fileprivate func getTitle(_ show: Show, _ season: Int) -> String {
  let preColon = "\(show.typeOfSeasons.localizeCapSing) \(season)"
  if let title = show.seasonTitles?[season] {
    return "\(preColon): \(title)"
  }
  return preColon
}

//struct SeasonView_Previews: PreviewProvider {
//    static var previews: some View {
//        SeasonView()
//    }
//}

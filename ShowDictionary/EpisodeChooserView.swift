//
//  EpisodeChooser.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 12/21/19.
//  Copyright © 2019 wilcoxcurtis. All rights reserved.
//

import SwiftUI

struct EpisodeChooserView: View {
  let navTitle: String
  let show: Show
  let useSections: Bool
  @State private(set) var episodes: [Episode] = []
  @State private var selected: (episode: Episode?, display: Bool) = (nil, false)
  
  var body: some View {
    ZStack {
      if let episode = selected.episode {
        NavigationLink(destination: EpisodeView(show: self.show, episode: episode), isActive: $selected.display) {
          EmptyView()
        }
      }
      GeometryReader { geometry in
        ScrollView {
          let width = geometry.size.width / 2.5
          LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 20) {
            ForEach(self.getSeasons(), id: \.self) { season in
              Section(header: useSections ?
                        AnyView(HStack {
                          Text(getSeasonText(self.show, season)).font(.title).bold()
                          VStack { Divider().padding(.horizontal) }
                        }.padding(.top)) : AnyView(EmptyView())) {
                ForEach(self.episodes.filter { $0.seasonNumber == season }) { episode in
                  EpisodeSquareView(selected: $selected, show: show, episode: episode, width: width)
                }
              }
            }
          }
          .padding(.horizontal)
        }
        .onAppear { selected = (nil, false) }
      }
    }
    .navigationBarTitle(self.navTitle)
  }
  
  private func getSeasons() -> [Int] {
    var seasons = [Int]()
    for season in 1...self.show.numberOfSeasons
    where !self.episodes.filter({ $0.seasonNumber == season }).isEmpty {
      seasons.append(season)
    }
    return seasons
  }
}

extension EpisodeChooserView {
  struct EpisodeSquareView: View {
    @Binding var selected: (episode: Episode?, display: Bool)
    let show: Show
    @ObservedObject var episode: Episode
    let width: CGFloat
    
    var body: some View {
      Button {
        selected = (episode, true)
      } label: {
        ZStack {
          RoundedRectangle(cornerRadius: 20)
            .stroke(Color(UIColor.label), lineWidth: 2)
            .frame(width: width)
            .padding(.horizontal)
          
          CardView(width: width, vertAlignment: .top, horizAlignment: .leading) {
            HStack(alignment: .top) {
              Text(episode.title)
                .font(.callout)
                .bold()
                .foregroundColor(Color(UIColor.label))
                .padding(.top)
              Spacer()
              VStack {
                Group {
                  Text("\(episode.seasonNumber < 10 ? "0" : "")\(episode.seasonNumber)")
                  Text("\(episode.numberInSeason < 10 ? "0" : "")\(episode.numberInSeason)")
                }
                .font(.footnote)
                .foregroundColor(Color(UIColor.label))
                Spacer()
              }
              .padding(.top)
            }
            Divider()
              .background(Color(UIColor.systemGray))
              .frame(width: width / 3)
              .padding(.all, 0)
            Group {
              HStack {
                SubText(episode.airdate.written(ms: 3))
                Spacer()
                Image(systemName: "star.fill")
                  .foregroundColor(episode.isFavorite ? .secondary : .clear)
              }
            }
            .padding(.bottom)
          }
        }
      }
//      .contextMenu {
//        Button(action: self.toggleFavoritism) {
//          HStack {
//            Text(self.episode.isFavorite ? NSLocalizedString("Unfavorite", comment: "") : NSLocalizedString("Favorite", comment: ""))
//            Image(systemName: "star\(self.episode.isFavorite ? "" : ".fill")")
//              .foregroundColor(.secondary)
//          }
//        }
//      }
    }
    
    private func seasonNum(_ episode: Episode) -> String {
      let seasonType = self.show.typeOfSeasons.localizeCapSing
      let seasonNum = episode.seasonNumber
      let episodeNum = episode.numberInSeason
      
      return "\(seasonType) \(seasonNum), \(NSLocalizedString("Episode", comment: "subtitle (doesn't get a number preceding)")) \(episodeNum)"
    }
    
    private func toggleFavoritism() {
      self.episode.isFavorite.toggle()
      if self.episode.isFavorite {
        updateServerEpisodeIsFavorite(filename: self.show.filename, code: self.episode.code) {
          self.episode.favoritedID = $0
        }
        self.show.hasFavoritedEpisodes = true
      } else {
        updateServerEpisodeIsNotFavorite(filename: self.show.filename, code: self.episode.code, id: self.episode.favoritedID!)
        self.episode.favoritedID = nil
//        for episode in self.show.episodes where !episode.isFavorite {
//          self.show.hasFavoritedEpisodes = false
//        }
        self.show.hasFavoritedEpisodes = (self.show.episodes.filter { $0.isFavorite }.count != 0)
      }
    }
  }
}
/*
extension EpisodeChooserView {
  
  struct EpisodeRow: View {
    let show: Show
    @ObservedObject private(set) var episode: Episode
    
    var body: some View {
      HStack {
        VStack(alignment: .leading) {
          Text(episode.title)
          SubText(self.seasonNum(episode))
          SubText(episode.airdate.written())
        }
        Spacer()
        Image(systemName: "star.fill")
          .foregroundColor(episode.isFavorite ? .secondary : .clear)
          .imageScale(.large)
      }
      .contextMenu {
        Button(action: self.toggleFavoritism) {
          HStack {
            Text(self.episode.isFavorite ? NSLocalizedString("Unfavorite", comment: "") : NSLocalizedString("Favorite", comment: ""))
            Image(systemName: "star\(self.episode.isFavorite ? "" : ".fill")")
              .foregroundColor(.secondary)
          }
        }
      }
    }
    
    private func seasonNum(_ episode: Episode) -> String {
      let seasonType = self.show.typeOfSeasons.localizeCapSing
      let seasonNum = episode.seasonNumber
      let episodeNum = episode.numberInSeason
      
      return "\(seasonType) \(seasonNum), \(NSLocalizedString("Episode", comment: "subtitle (doesn't get a number preceding)")) \(episodeNum)"
    }
    
    private func toggleFavoritism() {
      self.episode.isFavorite.toggle()
      if self.episode.isFavorite {
        updateServerEpisodeIsFavorite(filename: self.show.filename, code: self.episode.code) {
          self.episode.favoritedID = $0
        }
        self.show.hasFavoritedEpisodes = true
      } else {
        updateServerEpisodeIsNotFavorite(filename: self.show.filename, code: self.episode.code, id: self.episode.favoritedID!)
        self.episode.favoritedID = nil
//        for episode in self.show.episodes where !episode.isFavorite {
//          self.show.hasFavoritedEpisodes = false
//        }
        self.show.hasFavoritedEpisodes = (self.show.episodes.filter { $0.isFavorite }.count != 0)
      }
    }
  }
}
*/
//struct EpisodeChooser_Previews: PreviewProvider {
//    static var previews: some View {
//        EpisodeChooser()
//    }
//}

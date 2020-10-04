//
//  SearchMethodView.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 12/20/19.
//  Copyright © 2019 wilcoxcurtis. All rights reserved.
//

import SwiftUI

struct SearchMethodView: View {
  @ObservedObject private(set) var show: Show
  @ObservedObject private(set) var observer: EpisodeObserver
  @State private var progress: CGFloat = 0
  @State private var chosenMethod: (method: SearchMethod?, showing: Bool) = (nil, false)
  
  var body: some View {
    ZStack {
      if let method = chosenMethod.method {
        NavigationLink(destination: getDestination(method), isActive: $chosenMethod.showing) {
          EmptyView()
        }
      }
      if self.progress == 100 {
        GridView(show: self.show, progress: self.$progress, chosenMethod: self.$chosenMethod)
      }
      if self.progress != 100 && (self.show.episodes?.isEmpty ?? true) {
        ProgressView()
          .progressViewStyle(CircularProgressViewStyle())
      }
    }
    .navigationBarTitle(self.show.name)
    .onAppear {
      self.observer.getEpisodes { (episodes, hasFaves) in
        self.show.episodes = episodes
        self.show.hasFavoritedEpisodes = hasFaves
      }
      
      let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
        self.progress = CGFloat(self.observer.percentCompleted)
        if self.progress == 100 { timer.invalidate() }
      }
    }
  }
  
  init(show: Show) {
    self.show = show
    self.observer = EpisodeObserver(show.filename)
  }
  
  func getDestination(_ method: SearchMethod) -> some View {
    switch method {
    case .character:
      return AnyView(CharacterView(show: self.show))
    case .companion:
      return AnyView(CompanionView(show: self.show))
    case .description:
      return AnyView(DescriptionView(show: self.show))
    case .director:
      return AnyView(DirectorView(show: self.show))
    case .disc:
      return AnyView(DescriptionView(show: self.show))
    case .doctor:
      return AnyView(DoctorView(show: self.show))
    case .episodeNumber:
      return AnyView(DescriptionView(show: self.show))
    case .favorite:
      return AnyView(
        EpisodeChooserView(navTitle: NSLocalizedString("Favorite Episodes", comment: ""), show: self.show, episodes: self.show.episodes.filter { $0.isFavorite })
      )
    case .keyword:
      return AnyView(DescriptionView(show: self.show))
    /*case .name:
     return AnyView(DescriptionView(show: self.show))*/
    case .random:
      return AnyView(EpisodeView(show: self.show))//, episode: self.show.episodes.randomElement()!))
    case .rangeAirdates:
      return AnyView(DescriptionView(show: self.show))
    case .season:
      return AnyView(SeasonView(show: self.show))
    case .showAll:
      return AnyView(EpisodeChooserView(navTitle: NSLocalizedString("Episodes", comment: "navigation bar title"), show: self.show, episodes: self.show.episodes))
    case .singleAirdate:
      return AnyView(DescriptionView(show: self.show))
    case .writer:
      return AnyView(WriterView(show: self.show))
    }
  }
}

extension SearchMethodView {
  struct GridView: View {
    @ObservedObject var show: Show
    @Binding var progress: CGFloat
    @Binding var chosenMethod: (method: SearchMethod?, showing: Bool)
    
    var body: some View {
      GeometryReader { geometry in
        ScrollView {
          let offset: CGFloat = 30
          LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: offset) {
            ForEach(self.show.getAvailableSearchMethods()) { method in
              Button {
                chosenMethod = (method, true)
              } label: {
                let width = geometry.size.width / 2.25
                ZStack {
                  RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(UIColor.label), lineWidth: 2)
                    .frame(width: width)
                    .padding([.horizontal])
                  HStack {
                    VStack(alignment: .leading) {
                        Text(method.toString(seasonType: self.show.typeOfSeasons))
                          .font(.callout)
                          .bold()
                          .foregroundColor(Color(UIColor.label))
                          .padding(.top)
                        Divider()
                          .frame(width: width / 3)
                          .padding(.all, 0)
                        SubText(method.desc(seasonType: self.show.typeOfSeasons))
                          .padding(.bottom)
                      Spacer()
                    }
                    Spacer()
                  }
                  .frame(width: width - 20)
                  .frame(minHeight: (width / 2) - 20)
                }
              }
            }
          }
          .padding(.horizontal)
        }
        .onAppear { chosenMethod = (nil, false) }
      }
    }
  }
}

/*
struct SearchMethodView: View {
    @ObservedObject private(set) var show: Show
    @ObservedObject private(set) var observer: EpisodeObserver
    @State private var progress: CGFloat = 0
    
    var body: some View {
        ZStack {
            List((self.show.episodes?.isEmpty ?? true) ? [] : show.getAvailableSearchMethods()) { method in
                NavigationLink(destination: self.getDestination(method)) {
                    VStack(alignment: .leading) {
                        Text(method.toString(seasonType: self.show.typeOfSeasons))
                            .strikethrough([SearchMethod.keyword, SearchMethod.episodeNumber, SearchMethod.singleAirdate, SearchMethod.rangeAirdates, SearchMethod.disc].contains(method), color: Color(UIColor.label))
                        SubText(method.desc(seasonType: self.show.typeOfSeasons))
                    }
                }
            }
            .navigationBarTitle(self.show.name)
            .lineLimit(nil)
            .onAppear {
                self.observer.getEpisodes() { (episodes, hasFaves) in
                    self.show.episodes = episodes
                    self.show.hasFavoritedEpisodes = hasFaves
                }
                
                let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                    self.progress = CGFloat(self.observer.percentCompleted)
                    if self.progress == 100 { timer.invalidate() }
                }
            }
            if self.progress != 100 && (self.show.episodes?.isEmpty ?? true) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                
            }
        }
    }
    
    init(show: Show) {
        self.show = show
        self.observer = EpisodeObserver(show.filename)
    }
    
    func getDestination(_ method: SearchMethod) -> some View {
        switch method {
        case .character:
            return AnyView(CharacterView(show: self.show))
        case .companion:
            return AnyView(CompanionView(show: self.show))
        case .description:
            return AnyView(DescriptionView(show: self.show))
        case .director:
            return AnyView(DirectorView(show: self.show))
        case .disc:
            return AnyView(DescriptionView(show: self.show))
        case .doctor:
            return AnyView(DoctorView(show: self.show))
        case .episodeNumber:
            return AnyView(DescriptionView(show: self.show))
        case .favorite:
            return AnyView(
                EpisodeChooserView(navTitle: NSLocalizedString("Favorite Episodes", comment: ""), show: self.show, episodes: self.show.episodes.filter { $0.isFavorite })
            )
        case .keyword:
            return AnyView(DescriptionView(show: self.show))
        /*case .name:
         return AnyView(DescriptionView(show: self.show))*/
        case .random:
            return AnyView(EpisodeView(show: self.show))//, episode: self.show.episodes.randomElement()!))
        case .rangeAirdates:
            return AnyView(DescriptionView(show: self.show))
        case .season:
            return AnyView(SeasonView(show: self.show))
        case .showAll:
            return AnyView(EpisodeChooserView(navTitle: NSLocalizedString("Episodes", comment: "navigation bar title"), show: self.show, episodes: self.show.episodes))
        case .singleAirdate:
            return AnyView(DescriptionView(show: self.show))
        case .writer:
            return AnyView(WriterView(show: self.show))
        }
    }
}
*/
//#if DEBUG
//struct SearchMethodView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            EmptyView()
//        }
//    }
//}
//#endif


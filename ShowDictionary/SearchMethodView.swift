//
//  SearchMethodView.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 12/20/19.
//  Copyright © 2019 wilcoxcurtis. All rights reserved.
//

import SwiftUI

struct SearchMethodView: View {
  @EnvironmentObject var show: Show
  @ObservedObject private(set) var observer = EpisodeObserver()
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
        GridView(progress: self.$progress, chosenMethod: self.$chosenMethod)
      } else if self.progress != 100 && (self.show.episodes?.isEmpty ?? true) {
        ProgressView()
          .progressViewStyle(CircularProgressViewStyle())
          .scaleEffect(1.5)
      }
    }
    .navigationBarTitle(show.name)
    .onAppear {
      chosenMethod = (nil, false)
      guard observer.showname.isEmpty else { return }
      
      let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
        self.progress = CGFloat(observer.percentCompleted)
        if self.progress == 100 { timer.invalidate() }
      }
      
      observer.showname = self.show.filename
      observer.getEpisodes { (episodes, hasFaves) in
        show.episodes = episodes
        show.hasFavoritedEpisodes = hasFaves
        
        if let characters = show.characters {
          for episode in episodes {
            let chars = characters.filter { $0.appearances.contains(episode.code) }
            episode.setCharacters(chars)
          }
        }
      }
    }
  }
  
  func getDestination(_ method: SearchMethod) -> some View {
    switch method {
    case .character:
      return AnyView(CharacterView().environmentObject(show))
    case .companion:
      return AnyView(PersonView(searchMethod: .companion).environmentObject(show))
//      return AnyView(CompanionView().environmentObject(show))
    case .description:
      return AnyView(DescriptionView().environmentObject(show))
    case .director:
      return AnyView(PersonView(searchMethod: .director).environmentObject(show))
//      return AnyView(DirectorView().environmentObject(show))
    case .disc:
      return AnyView(DescriptionView().environmentObject(show))
    case .doctor:
      return AnyView(DoctorView().environmentObject(show))
    case .episodeNumber:
      return AnyView(DescriptionView().environmentObject(show))
    case .favorite:
      return AnyView(
        EpisodeChooserView(navTitle: NSLocalizedString("Favorite Episodes", comment: ""), useSections: true, episodes: self.show.episodes.filter { $0.isFavorite }).environmentObject(show)
      )
    case .keyword:
      return AnyView(DescriptionView().environmentObject(show))
    case .random:
      return AnyView(EpisodeView(episode: self.show.episodes.randomElement()!).environmentObject(show))
    case .rangeAirdates:
      return AnyView(AirdateView(searchMethod: .rangeAirdates).environmentObject(show))
    case .season:
      return AnyView(SeasonView().environmentObject(show))
    case .showAll:
      return AnyView(EpisodeChooserView(navTitle: NSLocalizedString("Episodes", comment: "navigation bar title"), useSections: true, episodes: self.show.episodes).environmentObject(show))
    case .singleAirdate:
      return AnyView(AirdateView(searchMethod: .singleAirdate).environmentObject(show))
    case .writer:
      return AnyView(PersonView(searchMethod: .writer).environmentObject(show))
//      return AnyView(WriterView().environmentObject(show))
    }
  }
}

extension SearchMethodView {
  struct GridView: View {
    @EnvironmentObject var show: Show
    @Binding var progress: CGFloat
    @Binding var chosenMethod: (method: SearchMethod?, showing: Bool)
    
    let columns = UIDevice.current.userInterfaceIdiom == .pad ? 3 : 2
    
    var body: some View {
      GeometryReader { geometry in
        ScrollView {
          LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: columns), spacing: 20) {
            ForEach(self.show.getAvailableSearchMethods()) { method in
              Button {
                chosenMethod = (method, true)
              } label: {
                let width = geometry.size.width / (CGFloat(columns) + 0.5)
                MethodView(method: method, width: width)
              }
            }
          }
          .padding(.horizontal)
        }
        .onAppear { chosenMethod = (nil, false) }
      }
    }
  }
  
  struct MethodView: View {
    @EnvironmentObject var show: Show
    let method: SearchMethod
    let width: CGFloat
    
    var body: some View {
      CardView(width: width, horizAlignment: .leading) {
        Text(method.toString(seasonType: self.show.typeOfSeasons))
          .font(.callout)
          .bold()
          .foregroundColor(Color(.label))
          .padding(.top)
        Divider()
          .background(Color.gray)
          .frame(width: width / 3)
          .padding(.all, 0)
        SubText(method.desc(seasonType: self.show.typeOfSeasons, numEpisodes: self.show.numberOfEpisodes))
          .padding(.bottom)
        Spacer()
      }
    }
  }
}

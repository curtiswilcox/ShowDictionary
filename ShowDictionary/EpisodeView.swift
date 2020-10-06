//
//  EpisodeView.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 12/20/19.
//  Copyright © 2019 wilcoxcurtis. All rights reserved.
//

//import Combine
import SwiftUI

struct EpisodeView: View {
  let show: Show
  @ObservedObject private(set) var episode: Episode
  
  var body: some View {
    VStack {
      ScrollView {
        HStack {
          Text(episode.summary)
            .lineSpacing(10)
            .padding(.all, 20)
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.leading)
          Spacer()
        }
      }
      Spacer()
      Toolbar(show: self.show, episode: self.episode)
    }
    .navigationBarTitle(episode.title)
  }
    
//    init(show: Show) {
//        self.show = show
//        self.episode = show.episodes.randomElement()!
//    }
    
  init(show: Show, episode: Episode) {
    self.show = show
    self.episode = episode
  }
}

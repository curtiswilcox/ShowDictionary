//
//  EpisodeView.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 12/20/19.
//  Copyright © 2019 wilcoxcurtis. All rights reserved.
//

import SwiftUI

struct EpisodeView: View {
  @EnvironmentObject var show: Show
  @ObservedObject var episode: Episode
  
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
      Toolbar(episode: self.episode).environmentObject(show)
    }
    .navigationBarTitle(episode.title)
  }
}

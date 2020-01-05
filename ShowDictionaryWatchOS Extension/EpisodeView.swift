//
//  EpisodeView.swift
//  ShowDictionaryWatchOS Extension
//
//  Created by Curtis Wilcox on 1/4/20.
//  Copyright © 2020 wilcoxcurtis. All rights reserved.
//

import Foundation
import SwiftUI

struct EpisodeView: View {
    let show: Show
    let episode: Episode
    
    var body: some View {
        ScrollView {
            Text(episode.summary)
        }
        .navigationBarTitle(episode.title)
    }
}

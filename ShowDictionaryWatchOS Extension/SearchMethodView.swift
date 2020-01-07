//
//  SearchMethodView.swift
//  ShowDictionaryWatchOS Extension
//
//  Created by Curtis Wilcox on 1/3/20.
//  Copyright © 2020 wilcoxcurtis. All rights reserved.
//

import SwiftUI

struct SearchMethodView: View {
    let show: Show
    
    private let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State private var timerTracker = 0
    
    @State private(set) var navTitle = String(format: NSLocalizedString("Loading%@", comment: ""), "")
    @State private(set) var methods: [SearchMethod] = []
    @State private(set) var shouldSpin: Bool = true
    
    var body: some View {
        ZStack {
            List(shouldSpin ? [] : methods) { method in
                NavigationLink(destination: self.getDestination(method)) {
                    HStack {
                        Divider()
                        Text(method.toString(seasonType: self.show.typeOfSeasons))
                    }
                }
                .padding([.top, .bottom], 5)
                .onAppear {
                    self.navTitle = NSLocalizedString("Options", comment: "")
                }
            }
        }
        .onAppear {
            EpisodeObserver(self.show.filename).getEpisodes() { (episodes, hasFaves) in
                self.show.episodes = episodes
                self.show.hasFavoritedEpisodes = hasFaves
                self.makeSearchMethods()
                self.shouldSpin = false
            }
        }
        .onReceive(timer) { _ in
            guard self.shouldSpin else { return }
            switch self.timerTracker {
            case 0:
                self.navTitle = String(format: NSLocalizedString("Loading%@", comment: ""), "")
                self.timerTracker = 1
            case 1:
                self.navTitle = String(format: NSLocalizedString("Loading%@", comment: ""), ".")
                self.timerTracker = 2
            case 2:
                self.navTitle = String(format: NSLocalizedString("Loading%@", comment: ""), "..")
                self.timerTracker = 3
            case 3:
                self.navTitle = String(format: NSLocalizedString("Loading%@", comment: ""), "...")
                self.timerTracker = 0
            default:
                print("Default case... whoops.")
            }
        }
        .navigationBarTitle(self.navTitle)
    }
    
    private func makeSearchMethods() {
        var methods: [SearchMethod] = []
        methods.append(contentsOf: [.description, .season, .showAll, .random])
        if show.hasFavoritedEpisodes { methods.append(.favorite) }
        
        self.methods = methods
    }
    
    private func getDestination(_ method: SearchMethod) -> some View {
        switch method {
        case .description: return AnyView(DescriptionView(show: self.show))
        case .favorite: return AnyView(EpisodeChooserView(show: self.show, episodes: self.show.episodes.filter({ $0.isFavorite }), navTitle: NSLocalizedString("Favorites", comment: "Nav bar title for favorite episodes")))
        case .season: return AnyView(SeasonView(show: self.show))
        case .showAll: return AnyView(EpisodeChooserView(show: self.show, episodes: self.show.episodes, navTitle: NSLocalizedString("Episodes", comment: "Navigation bar title")))
        case .random: return AnyView(EpisodeView(show: self.show, episode: self.show.episodes.randomElement()!))
        default: return AnyView(DescriptionView(show: self.show))
        }
    }
}

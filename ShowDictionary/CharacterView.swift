//
//  CharacterView.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 12/24/19.
//  Copyright © 2019 wilcoxcurtis. All rights reserved.
//

import SwiftUI

struct CharacterView: View {
    let show: Show
    
    var body: some View {
        List(show.characters!) { character in
            NavigationLink(destination: EpisodeChooserView(navTitle: "\(String(format: NSLocalizedString("Episodes with %@", comment: ""), character.character))", show: self.show, episodes: self.epsWithChar(character))) {
                VStack(alignment: .leading) {
                    Text(character.character)
                    HStack {
                        SubText(character.actor)
                        Spacer()
                        SubText("episode".localizeWithFormat(quantity: self.getNumEps(character)).capitalized)
                    }
                }
            }
        }
        .navigationBarTitle("character".localizeWithFormat(quantity: 2).capitalized)
    }
    
    private func epsWithChar(_ character: Show.Character) -> [Episode] {
        
        return show.episodes.filter {
            $0.characters?.contains(character) ?? false
        }
    }
    
    private func getNumEps(_ character: Show.Character) -> Int {
        return epsWithChar(character).count
    }
}

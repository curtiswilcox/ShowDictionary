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
        List {
            ForEach(self.getSectionHeaders(), id: \.self) { header in
                Section(header: Text(header)) {
                    ForEach(self.getCharacters().filter { $0.character.lastName.firstLetter() == header }, id: \.self) { character in
                        CharacterRow(show: self.show, character: character)
                    }
                }
            }
        }
        .navigationBarTitle("character".localizeWithFormat(quantity: self.getCharacters().count).capitalized)
    }
    
    private func getSectionHeaders() -> [String] {
        return Set(getCharacters().map { $0.character.lastName.firstLetter().uppercased() }).sorted()
    }
    
    private func getCharacters() -> [Show.Character] {
        var characters = [Show.Character]()
        for episode in self.show.episodes {
            for character in episode.characters! {
                characters.append(character)
            }
        }
        return Set(characters).sorted(by: { $0.character < $1.character })
    }
}

extension CharacterView {
    struct CharacterRow: View {
        let show: Show
        let character: Show.Character
        
        var body: some View {
            NavigationLink(destination: EpisodeChooserView(navTitle: "\(String(format: NSLocalizedString("Episodes with %@", comment: ""), character.character.fullName))", show: self.show, episodes: self.epsWithChar(character))) {
                VStack(alignment: .leading) {
                    Text(character.character.fullName)
                    HStack {
                        SubText(character.actor.fullName)
                        Spacer()
                        SubText("episode".localizeWithFormat(quantity: self.getNumEps(character)).capitalized)
                    }
                }
            }
        }
        
        private func getNumEps(_ character: Show.Character) -> Int {
            return epsWithChar(character).count
        }
        
        private func epsWithChar(_ character: Show.Character) -> [Episode] {
            return show.episodes.filter { $0.characters?.contains(character) ?? false }
        }
    }
}

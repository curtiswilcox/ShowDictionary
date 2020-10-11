//
//  CharacterView.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 12/24/19.
//  Copyright © 2019 wilcoxcurtis. All rights reserved.
//

import SwiftUI

struct CharacterView: View {
  @EnvironmentObject var show: Show
  @State var characterSelected: (character: Show.Character?, showing: Bool) = (nil, false)
  
  var body: some View {
    ZStack {
      if let character = characterSelected.character {
//        let navTitle = "\(String(format: NSLocalizedString("Episodes with %@", comment: ""), character.character.fullName))"
        let navTitle = "\(String(format: NSLocalizedString("%@", comment: ""), character.character.fullName))"
        let episodesToPass = epsWithChar(character, show: show)
        NavigationLink(destination: EpisodeChooserView(navTitle: navTitle, useSections: true, episodes: episodesToPass).environmentObject(show), isActive: $characterSelected.showing) {
          EmptyView()
        }
      }
      GeometryReader { geometry in
        ScrollView {
          let width = geometry.size.width / 2.5
          GridView(characterSelected: $characterSelected, width: width)
            .onAppear { characterSelected = (nil, false) }
        }
      }
    }
    .navigationBarTitle("character".localizeWithFormat(quantity: getCharacters(show: show).count).capitalized)
  }
}

extension CharacterView {
  struct GridView: View {
    @EnvironmentObject var show: Show
    @Binding var characterSelected: (character: Show.Character?, showing: Bool)
    let width: CGFloat
    
    var body: some View {
      LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 20) {
        ForEach(getSectionHeaders(show: show), id: \.self) { header in
          Section(header:
                    HStack {
                      VStack { Divider().padding(.horizontal) }
                      Text(header).font(.title).bold()
                      VStack { Divider().padding(.horizontal) }
                    }) {
            ForEach(getCharacters(show: show).filter { $0.character.lastName.firstLetter() == header }, id: \.self) { character in
              Button {
                characterSelected = (character, true)
              } label: {
                CardView(width: width, vertAlignment: .top) {
                  Text(character.character.fullName)
                    .font(.callout)
                    .bold()
                    .foregroundColor(Color(UIColor.label))
                    .padding(.top)
                  SubText(character.actor.fullName)
                  Spacer()
                  Divider()
                    .background(Color(UIColor.systemGray))
                    .frame(width: width / 3)
                    .padding(.all, 0)
                  SubText("episode".localizeWithFormat(quantity: getNumEps(character, show: show)))
                    .padding(.bottom)
                }
              }
            }
          }
        }
      }
      .padding(.horizontal)
    }
  }
}

fileprivate func getNumEps(_ character: Show.Character, show: Show) -> Int {
  return epsWithChar(character, show: show).count
}

fileprivate func epsWithChar(_ character: Show.Character, show: Show) -> [Episode] {
  return show.episodes.filter { $0.characters?.contains(character) ?? false }
}

fileprivate func getSectionHeaders(show: Show) -> [String] {
  return Set(getCharacters(show: show).map { $0.character.lastName.firstLetter().uppercased() }).sorted()
}

fileprivate func getCharacters(show: Show) -> [Show.Character] {
  var characters = [Show.Character]()
  for episode in show.episodes {
    for character in episode.characters! {
      characters.append(character)
    }
  }
  return Set(characters).sorted(by: { $0.character < $1.character })
}

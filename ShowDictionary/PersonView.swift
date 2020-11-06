//
//  PersonView.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 11/4/20.
//  Copyright © 2020 wilcoxcurtis. All rights reserved.
//

import SwiftUI

struct PersonView: View {
  @EnvironmentObject var show: Show
  @State var personSelected: (person: Person?, showing: Bool) = (nil, false)
  let searchMethod: SearchMethod
  
  var body: some View {
    if let person = personSelected.person {
      let navTitle = String(format: NSLocalizedString("%@", comment: ""), person.fullName)
      let episodesToPass = show.episodes.filter { episode in episode.writers!.contains(person) }
      
      NavigationLink(destination: EpisodeChooserView(navTitle: navTitle, useSections: true, episodes: episodesToPass).environmentObject(show), isActive: $personSelected.showing) {
        EmptyView()
      }
    }
    GeometryReader { geometry in
      ScrollView {
        GridView(personSelected: $personSelected, geometry: geometry, searchMethod: searchMethod)
          .onAppear { personSelected = (nil, false) }
      }
    }
    .navigationBarTitle("writer".localizeWithFormat(quantity: getPeople(show: show, type: searchMethod).count).capitalized)
  }
}


extension PersonView {
  struct GridView: View {
    @EnvironmentObject var show: Show
    @Binding var personSelected: (person: Person?, showing: Bool)
    let geometry: GeometryProxy
    let searchMethod: SearchMethod
    
    var body: some View {
      LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 20) {
        ForEach(getSectionHeaders(show: show, type: searchMethod), id: \.self) { header in
          Section(header:
                    SectionHeaderView<Text>(width: geometry.size.width) { Text(header) }) {
            ForEach(getPeople(show: show, type: searchMethod).filter { $0.lastName.firstLetter() == header }, id: \.self) { person in
              Button {
                personSelected = (person, true)
              } label: {
                let cardWidth = geometry.size.width / 2.5
                CardView(width: cardWidth, vertAlignment: .top) {
                  Text(person.fullName)
                    .font(.callout)
                    .bold()
                    .foregroundColor(Color(UIColor.label))
                    .padding(.top)
                  Spacer()
                  Divider()
                    .background(Color.gray)
                    .frame(width: cardWidth / 3)
                    .padding(.all, 0)
                  SubText("episode".localizeWithFormat(quantity: getNumEps(person, show: show, type: searchMethod)))
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

fileprivate func getPeople(show: Show, type: SearchMethod) -> [Person] {
//  var people = [Person]()
//  for episode in show.episodes {
//    for writer in episode.writers! {
//      people.append(writer)
  //    }
  //  }
  return Set(show.episodes.compactMap({ type == .director ? $0.directors : type == .writer ? $0.writers : $0.companions }).reduce([], +)).sorted()
}

fileprivate func getSectionHeaders(show: Show, type: SearchMethod) -> [String] {
  return Set(getPeople(show: show, type: type).map { $0.lastName.first!.uppercased() }).sorted()
}

fileprivate func getNumEps(_ person: Person, show: Show, type: SearchMethod) -> Int {
  switch type {
//  case .character:
//    return show.episodes.filter { $0.characters!.contains(person) }.count
  case .companion:
    return show.episodes.filter { $0.companions!.contains(person) }.count
  case .director:
    return show.episodes.filter { $0.directors!.contains(person) }.count
  case .writer:
    return show.episodes.filter { $0.writers!.contains(person) }.count
  default:
    fatalError("Unknown search method! \(#function), \(#line)")
  }
}

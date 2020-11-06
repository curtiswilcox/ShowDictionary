////
////  DirectorView.swift
////  ShowDictionary
////
////  Created by Curtis Wilcox on 12/23/19.
////  Copyright © 2019 wilcoxcurtis. All rights reserved.
////
//
//import SwiftUI
//
//struct DirectorView: View {
//  @EnvironmentObject var show: Show
//  @State var directorSelected: (director: Person?, showing: Bool) = (nil, false)
//
//  var body: some View {
//    if let director = directorSelected.director {
////      let navTitle = "\(String(format: NSLocalizedString("Episodes with %@", comment: ""), director.fullName))"
//      let navTitle = String(format: NSLocalizedString("%@", comment: ""), director.fullName)
//      let episodesToPass = show.episodes.filter { episode in episode.directors!.contains(director) }
//
//      NavigationLink(destination: EpisodeChooserView(navTitle: navTitle, useSections: true, episodes: episodesToPass).environmentObject(show), isActive: $directorSelected.showing) {
//        EmptyView()
//      }
//    }
//    GeometryReader { geometry in
//      ScrollView {
//        GridView(directorSelected: $directorSelected, geometry: geometry)
//          .onAppear { directorSelected = (nil, false) }
//      }
//    }
//    .navigationBarTitle("director".localizeWithFormat(quantity: getDirectors(show: show).count).capitalized)
//  }
//}
//
//
//extension DirectorView {
//  struct GridView: View {
//    @EnvironmentObject var show: Show
//    @Binding var directorSelected: (director: Person?, showing: Bool)
//    let geometry: GeometryProxy
//
//    var body: some View {
//      LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 20) {
//        ForEach(getSectionHeaders(show: show), id: \.self) { header in
//          Section(header: SectionHeaderView<Text>(width: geometry.size.width) { Text(header) }) {
//            ForEach(getDirectors(show: show).filter { $0.lastName.firstLetter() == header }, id: \.self) { director in
//              Button {
//                directorSelected = (director, true)
//              } label: {
//                let cardWidth = geometry.size.width / 2.5
//                CardView(width: cardWidth, vertAlignment: .top) {
//                  Text(director.fullName)
//                    .font(.callout)
//                    .bold()
//                    .foregroundColor(Color(UIColor.label))
//                    .padding(.top)
//                  Spacer()
//                  Divider()
//                    .background(Color.gray)
//                    .frame(width: cardWidth / 3)
//                    .padding(.all, 0)
//                  SubText("episode".localizeWithFormat(quantity: getNumEps(director, show: show)))
//                    .padding(.bottom)
//                }
//              }
//            }
//          }
//        }
//      }
//      .padding(.horizontal)
//    }
//  }
//}
//
//fileprivate func getDirectors(show: Show) -> [Person] {
//  var directors = [Person]()
//  for episode in show.episodes {
//    for director in episode.directors! {
//      directors.append(director)
//    }
//  }
//  return Set(directors).sorted()
//}
//
//fileprivate func getSectionHeaders(show: Show) -> [String] {
//  return Set(getDirectors(show: show).map { $0.lastName.first!.uppercased() }).sorted()
//}
//
//fileprivate func getNumEps(_ director: Person, show: Show) -> Int {
//  return show.episodes.filter { $0.directors!.contains(director) }.count
//}

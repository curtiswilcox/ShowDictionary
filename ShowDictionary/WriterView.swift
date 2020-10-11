//
//  WriterView.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 12/23/19.
//  Copyright © 2019 wilcoxcurtis. All rights reserved.
//

import SwiftUI

struct WriterView: View {
  @EnvironmentObject var show: Show
  @State var writerSelected: (writer: Person?, showing: Bool) = (nil, false)
  
  var body: some View {
    if let writer = writerSelected.writer {
//      let navTitle = "\(String(format: NSLocalizedString("Episodes with %@", comment: ""), writer.fullName))"
      let navTitle = String(format: NSLocalizedString("%@", comment: ""), writer.fullName)
      let episodesToPass = show.episodes.filter { episode in episode.writers!.contains(writer) }
      
      NavigationLink(destination: EpisodeChooserView(navTitle: navTitle, useSections: true, episodes: episodesToPass).environmentObject(show), isActive: $writerSelected.showing) {
        EmptyView()
      }
    }
    GeometryReader { geometry in
      ScrollView {
        let width = geometry.size.width / 2.5
        GridView(writerSelected: $writerSelected, width: width)
          .onAppear { writerSelected = (nil, false) }
      }
    }
    .navigationBarTitle("writer".localizeWithFormat(quantity: getWriters(show: show).count).capitalized)
  }
}


extension WriterView {
  struct GridView: View {
    @EnvironmentObject var show: Show
    @Binding var writerSelected: (writer: Person?, showing: Bool)
    let width: CGFloat
    
    var body: some View {
      LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 20) {
        ForEach(getSectionHeaders(show: show), id: \.self) { header in
          Section(header:
                    HStack {
//                      VStack { Divider().padding(.horizontal) }
                      Text(header).font(.title).bold()
                      Spacer()
//                      VStack { Divider().padding(.horizontal) }
                    }.padding([.top, .horizontal])) {
            ForEach(getWriters(show: show).filter { $0.lastName.firstLetter() == header }, id: \.self) { writer in
              Button {
                writerSelected = (writer, true)
              } label: {
                CardView(width: width, vertAlignment: .top) {
                  Text(writer.fullName)
                    .font(.callout)
                    .bold()
                    .foregroundColor(Color(UIColor.label))
                    .padding(.top)
                  Spacer()
                  Divider()
                    .background(Color(UIColor.systemGray))
                    .frame(width: width / 3)
                    .padding(.all, 0)
                  SubText("episode".localizeWithFormat(quantity: getNumEps(writer, show: show)))
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

fileprivate func getWriters(show: Show) -> [Person] {
  var writers = [Person]()
  for episode in show.episodes {
    for writer in episode.writers! {
      writers.append(writer)
    }
  }
  return Set(writers).sorted()
}

fileprivate func getSectionHeaders(show: Show) -> [String] {
  return Set(getWriters(show: show).map { $0.lastName.first!.uppercased() }).sorted()
}

fileprivate func getNumEps(_ writer: Person, show: Show) -> Int {
  return show.episodes.filter { $0.writers!.contains(writer) }.count
}

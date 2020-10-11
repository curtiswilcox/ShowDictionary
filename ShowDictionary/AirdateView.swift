//
//  AirdateView.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 10/10/20.
//  Copyright © 2020 wilcoxcurtis. All rights reserved.
//

import Foundation
import SwiftUI

struct AirdateView: View {
  @EnvironmentObject var show: Show
  @State var after = Date() {
    didSet {
      guard searchMethod == .singleAirdate else { return }
      before = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: after)!
    }
  }
  @State var before = Date()
  @State var go = false
  let searchMethod: SearchMethod
  
  var body: some View {
    let navTitle: String = {
      if searchMethod == .singleAirdate {
        return "Episodes around \(after.written(ms: 4))"
      }
      return "Episodes between \(after.written(ms: 3)) and \(before.written(ms: 3))"
    }()
    
    let episodesToPass = show.episodes.filter { $0.airdate >= after && $0.airdate < before }
    
    let msg: String = {
      if searchMethod == .singleAirdate {
        return "All episodes of \(show.name) that aired within one week of the selected date will be displayed."
      }
      return "All episodes of \(show.name) that aired between the selected dates will be displayed."
    }()
    
    ScrollView {
      ZStack {
        NavigationLink(destination: EpisodeChooserView(navTitle: navTitle, useSections: Set(episodesToPass.map { $0.seasonNumber }).count > 1, episodes: episodesToPass).environmentObject(show), isActive: $go) {
          EmptyView()
        }
        VStack {
          let range = show.episodes.first!.airdate...show.episodes.last!.airdate
          Text(msg)
            .font(.headline)
            .padding()
          DatePicker("", selection: $after, in: range, displayedComponents: .date)
            .datePickerStyle(GraphicalDatePickerStyle())
            .labelsHidden()
            .padding(.vertical)
          if searchMethod == .rangeAirdates {
            Divider()
              .padding()
            DatePicker("Episodes before:", selection: $before, in: range, displayedComponents: .date)
              .datePickerStyle(GraphicalDatePickerStyle())
              .labelsHidden()
              .padding(.vertical)
          }
          Divider()
            .padding()
          Button {
            go.toggle()
          } label: {
            Text("Display episodes")
              .padding()
              .overlay(
                RoundedRectangle(cornerRadius: 20)
                  .stroke(Color(UIColor.label), lineWidth: 2)
              )
          }
          .padding()
          Spacer()
        }
      }
    }
    .navigationTitle("Date Selection")
    .onAppear { self.after = self.show.episodes.first!.airdate }
  }
}

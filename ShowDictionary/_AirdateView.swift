/*
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
  @State var after = Date(hyphenated: "1911-01-01")
  @State var before = Date()
  @State var go = false
  @State var showNoEpisodeAlert = false
  let searchMethod: SearchMethod
  
  var body: some View {
    let afterCenturyAgo = Calendar.current.component(.year, from: after) + 100 < Calendar.current.component(.year, from: Date())
    let beforeCenturyAgo = Calendar.current.component(.year, from: before) + 100 < Calendar.current.component(.year, from: Date()) // if true, then date is over 100 years ago
    let navTitle = (searchMethod == .singleAirdate ? after.written() : "\(after.written(ys: (afterCenturyAgo ? 1 : 2), ms: 2, ds: 2)) - \(before.written(ys: (beforeCenturyAgo ? 1 : 2), ms: 2, ds: 2))")
    
    ScrollView {
      ZStack {
        let episodesToPass = show.episodes.filter { searchMethod == .singleAirdate ? $0.airdate == after : $0.airdate >= after && $0.airdate < before }
        if episodesToPass.count > 1 {
          NavigationLink(destination: EpisodeChooserView(navTitle: navTitle, useSections: Set(episodesToPass.map { $0.seasonNumber }).count > 1, episodes: episodesToPass).environmentObject(show), isActive: $go) {
            EmptyView()
          }
        } else if !episodesToPass.isEmpty {
          NavigationLink(destination: EpisodeView(episode: episodesToPass.first!).environmentObject(show), isActive: $go) {
            EmptyView()
          }
        }
        VStack(alignment: .leading) {
          DateView(after: $after, before: $before, searchMethod: searchMethod)
          Divider().padding()
          DisplayEpisodeButton(go: $go, showNoEpisodeAlert: $showNoEpisodeAlert, episodesToPass: episodesToPass)
          Spacer()
        }
      }
    }
    .navigationTitle(NSLocalizedString("Airdate Selection", comment: ""))
    .onAppear {
      if self.after == Date(hyphenated: "1911-01-01") {
        self.before = self.show.episodes.last!.airdate
        self.after = self.show.episodes.first!.airdate
      }
    }
    .alert(isPresented: $showNoEpisodeAlert) {
      let alertText = "No episodes aired \(searchMethod == .singleAirdate ? "on the given date" : "in the given time frame")."
      return Alert(title: Text(NSLocalizedString("No episodes", comment: "")), message: Text(NSLocalizedString(alertText, comment: "")), dismissButton: .default(Text(NSLocalizedString("Dismiss", comment: ""))))
    }
  }
}

extension AirdateView {
  struct DateView: View {
    @EnvironmentObject var show: Show
    @Binding var after: Date
    @Binding var before: Date
    let searchMethod: SearchMethod
    
    var body: some View {
      let msg: String = {
        if searchMethod == .singleAirdate {
          return String(format: NSLocalizedString("All episodes of %@ that aired on the selected date will be displayed.", comment: ""), show.name)
        }
        return String(format: NSLocalizedString("All episodes of %@ that aired between the selected dates will be displayed.", comment: ""), show.name)
      }()
      
      let range = show.episodes.first!.airdate...show.episodes.last!.airdate
      Text(msg)
        .font(.headline)
        .padding()
      DatePicker("", selection: $after, in: range, displayedComponents: .date)
        .datePickerStyle(GraphicalDatePickerStyle())
        .labelsHidden()
        .padding()
      if searchMethod == .rangeAirdates {
        Divider()
          .padding()
        DatePicker("", selection: $before, in: after...show.episodes.last!.airdate, displayedComponents: .date)
          .datePickerStyle(GraphicalDatePickerStyle())
          .labelsHidden()
          .padding()
      }
    }
  }
  
  struct DisplayEpisodeButton: View {
    @Binding var go: Bool
    @Binding var showNoEpisodeAlert: Bool
    let episodesToPass: [Episode]
    
    var body: some View {
      HStack {
        Spacer()
        Button {
          guard !episodesToPass.isEmpty else {
            showNoEpisodeAlert.toggle()
            return
          }
          go.toggle()
        } label: {
          Text(NSLocalizedString("Display", comment: ""))
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(.label), lineWidth: 2))
        }
        .padding(.vertical)
        Spacer()
      }
    }
  }
}
*/

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
  @State var after = Date(hyphenated: "1911-01-01") {
    didSet {
      guard searchMethod == .singleAirdate else { return }
      before = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: after)!
    }
  }
  @State var before = Date()
  @State var go = false
  @State var showNoEpisodeAlert = false
  let searchMethod: SearchMethod
  
  var body: some View {
    let navTitle: String = {
      if searchMethod == .singleAirdate {
        return after.written(ys: 2, ms: 2)
      }
      return "\(after.written(ys: 2, ms: 2)) - \(before.written(ys: 2, ms: 2))"
    }()
    
    let msg: String = {
      if searchMethod == .singleAirdate {
        return String(format: NSLocalizedString("All episodes of %@ that aired within one week of the selected date will be displayed.", comment: ""), show.name)
      }
      return String(format: NSLocalizedString("All episodes of %@ that aired between the selected dates will be displayed.", comment: ""), show.name)
    }()
    
    ScrollView {
      ZStack {
        let episodesToPass = show.episodes.filter { $0.airdate >= after && $0.airdate < before }
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
            DatePicker("", selection: $before, in: after...show.episodes.last!.airdate, displayedComponents: .date)
              .datePickerStyle(GraphicalDatePickerStyle())
              .labelsHidden()
              .padding(.vertical)
          }
          Divider()
            .padding()
          Button {
            guard !episodesToPass.isEmpty else {
              showNoEpisodeAlert.toggle()
              return
            }
            go.toggle()
          } label: {
            Text(NSLocalizedString("Display episodes", comment: ""))
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
    .navigationTitle(NSLocalizedString("Airdate Selection", comment: ""))
    .onAppear {
      if self.after == Date(hyphenated: "1911-01-01") {
        self.before = self.show.episodes.last!.airdate
        self.after = self.show.episodes.first!.airdate
      }
    }
    .alert(isPresented: $showNoEpisodeAlert) {
      Alert(title: Text(NSLocalizedString("No episodes", comment: "")), message: Text(NSLocalizedString("No episodes aired in the given time frame.", comment: "")), dismissButton: .default(Text(NSLocalizedString("Dismiss", comment: ""))))
    }
  }
}

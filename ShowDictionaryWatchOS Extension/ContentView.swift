/*
//
//  ContentView.swift
//  ShowDictionaryWatchOS Extension
//
//  Created by Curtis Wilcox on 1/3/20.
//  Copyright © 2019 wilcoxcurtis. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  @ObservedObject var observer = ShowObserver()
  
  var body: some View {
    if #available(watchOS 7.0, *), self.observer.data.isEmpty {
      ProgressView()
        .navigationBarTitle(NSLocalizedString("Home", comment: ""))
    } else {
      List {
        ForEach(self.getSectionHeaders(), id: \.self) { header in
          Section(header: Text(header)) {
            ForEach(self.observer.data.filter { $0.name.firstLetter() == header }) { show in
              NavigationLink(destination: SearchMethodView(show: show)) {
                HStack {
                  Divider()
                    .background(self.getColor(show.name.firstLetter()))
                  Text(show.name)
                }
              }
              .padding([.top, .bottom], 5)
            }
          }
        }
      }
      .navigationBarTitle(NSLocalizedString("Home", comment: ""))
    }
  }
  
  private func getSectionHeaders() -> [String] {
    guard !observer.data.isEmpty else { return [] }
    var headers = Set<String>()
    for show in observer.data {
      let firstLetter = show.name.firstLetter()
      headers.insert(firstLetter.uppercased())
    }
    return headers.sorted()
  }
  
  private func getColor(_ firstLetter: String) -> Color {
    switch firstLetter.lowercased() {
    case "a": return Color(red: 240/255, green: 163/255, blue: 255/255) // amethyst
    case "b": return Color(red: 0/255, green: 117/255, blue: 220/255) // blue
    case "c": return Color(red: 153/255, green: 63/255, blue: 0/255) // caramel
    case "d": return Color(red: 76/255, green: 0/255, blue: 92/255) // damson
    case "e": return Color(red: 25/255, green: 25/255, blue: 25/255) //ebony
    case "f": return Color(red: 0/255, green: 92/255, blue: 49/255) // forest
    case "g": return Color(red: 43/255, green: 206/255, blue: 72/255) // green
    case "h": return Color(red: 255/255, green: 204/255, blue: 153/255) // honeydew
    case "i": return Color(red: 128/255, green: 128/255, blue: 128/255) // iron
    case "j": return Color(red: 148/255, green: 255/255, blue: 181/255) // jade
    case "k": return Color(red: 143/255, green: 124/255, blue: 0/255) // khaki
    case "l": return Color(red: 157/255, green: 204/255, blue: 0/255) // lime
    case "m": return Color(red: 194/255, green: 0/255, blue: 136/255) // mallow
    case "n": return Color(red: 0/255, green: 51/255, blue: 128/255) // navy
    case "o": return Color(red: 255/255, green: 164/255, blue: 5/255) // orpiment
    case "p": return Color(red: 255/255, green: 168/255, blue: 187/255) // pink
    case "q": return Color(red: 66/255, green: 102/255, blue: 0/255) // quagmire
    case "r": return Color(red: 255/255, green: 0/255, blue: 16/255) // red
    case "s": return Color(red: 94/255, green: 241/255, blue: 242/255) // sky
    case "t": return Color(red: 0/255, green: 153/255, blue: 143/255) // turquoise
    case "u": return Color(red: 224/255, green: 255/255, blue: 102/255) // uranium
    case "v": return Color(red: 116/255, green: 10/255, blue: 255/255) // violet
    case "w": return Color(red: 153/255, green: 0/255, blue: 0/255) // wine
    case "x": return Color(red: 255/255, green: 255/255, blue: 128/255) // xanthin
    case "y": return Color(red: 255/255, green: 255/255, blue: 0/255) // yellow
    case "z": return Color(red: 255/255, green: 80/255, blue: 5/255) // zinnia
    default: return .clear
    }
  }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
#endif
*/

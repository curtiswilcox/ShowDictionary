//
//  ContentView.swift
//  ShowDictionaryWatchOS Extension
//
//  Created by Curtis Wilcox on 1/3/20.
//  Copyright © 2019 wilcoxcurtis. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var shows: [Show] = [Show(name: "Castle"), Show(name: "Doctor Who"), Show(name: "A Series of Unfortunate Events")].sorted()
    
    var body: some View {
        List(shows) { show in
            NavigationLink(destination: SearchMethodView()) {
                HStack {
                    Divider()
                        .foregroundColor(self.getColor(show.firstLetter()))
                    Text(show.name)
                }
            }
        }
    }
    
    private func getColor(_ firstLetter: String) -> Color {
        switch firstLetter {
        case "a": return .blue
        case "b": return .blue
        case "c": return .blue
        case "d": return .blue
        case "e": return .blue
        case "f": return .blue
        case "g": return .blue
        case "h": return .blue
        case "i": return .blue
        case "j": return .blue
        case "k": return .blue
        case "l": return .blue
        case "m": return .blue
        case "n": return .blue
        case "o": return .blue
        case "p": return .blue
        case "q": return .blue
        case "r": return .blue
        case "s": return .blue
        case "t": return .blue
        case "u": return .blue
        case "v": return .blue
        case "w": return .blue
        case "x": return .blue
        case "y": return .blue
        case "z": return .blue
        default: return .blue
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

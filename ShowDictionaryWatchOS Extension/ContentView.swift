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
        List(observer.data) { show in
            NavigationLink(destination: SearchMethodView(show: show)) {
                HStack {
                    Divider()
                        .background(self.getColor(show.firstLetter()))
                    Text(show.name)
                }
            }
            .padding([.top, .bottom], 5)
        }
        .navigationBarTitle(NSLocalizedString("Home", comment: ""))
    }
    
    private func getColor(_ firstLetter: String) -> Color {
        switch firstLetter.lowercased() {
        case "a": return Color(UIColor(red: 240/255, green: 163/255, blue: 255/255, alpha: 1)) // amethyst
        case "b": return Color(UIColor(red: 0/255, green: 117/255, blue: 220/255, alpha: 1)) // blue
        case "c": return Color(UIColor(red: 153/255, green: 63/255, blue: 0/255, alpha: 1)) // caramel
        case "d": return Color(UIColor(red: 76/255, green: 0/255, blue: 92/255, alpha: 1)) // damson
        case "e": return Color(UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)) //ebony
        case "f": return Color(UIColor(red: 0/255, green: 92/255, blue: 49/255, alpha: 1)) // forest
        case "g": return Color(UIColor(red: 43/255, green: 206/255, blue: 72/255, alpha: 1)) // green
        case "h": return Color(UIColor(red: 255/255, green: 204/255, blue: 153/255, alpha: 1)) // honeydew
        case "i": return Color(UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1)) // iron
        case "j": return Color(UIColor(red: 148/255, green: 255/255, blue: 181/255, alpha: 1)) // jade
        case "k": return Color(UIColor(red: 143/255, green: 124/255, blue: 0/255, alpha: 1)) // khaki
        case "l": return Color(UIColor(red: 157/255, green: 204/255, blue: 0/255, alpha: 1)) // lime
        case "m": return Color(UIColor(red: 194/255, green: 0/255, blue: 136/255, alpha: 1)) // mallow
        case "n": return Color(UIColor(red: 0/255, green: 51/255, blue: 128/255, alpha: 1)) // navy
        case "o": return Color(UIColor(red: 255/255, green: 164/255, blue: 5/255, alpha: 1)) // orpiment
        case "p": return Color(UIColor(red: 255/255, green: 168/255, blue: 187/255, alpha: 1)) // pink
        case "q": return Color(UIColor(red: 66/255, green: 102/255, blue: 0/255, alpha: 1)) // quagmire
        case "r": return Color(UIColor(red: 255/255, green: 0/255, blue: 16/255, alpha: 1)) // red
        case "s": return Color(UIColor(red: 94/255, green: 241/255, blue: 242/255, alpha: 1)) // sky
        case "t": return Color(UIColor(red: 0/255, green: 153/255, blue: 143/255, alpha: 1)) // turquoise
        case "u": return Color(UIColor(red: 224/255, green: 255/255, blue: 102/255, alpha: 1)) // uranium
        case "v": return Color(UIColor(red: 116/255, green: 10/255, blue: 255/255, alpha: 1)) // violet
        case "w": return Color(UIColor(red: 153/255, green: 0/255, blue: 0/255, alpha: 1)) // wine
        case "x": return Color(UIColor(red: 255/255, green: 255/255, blue: 128/255, alpha: 1)) // xanthin
        case "y": return Color(UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 1)) // yellow
        case "z": return Color(UIColor(red: 255/255, green: 80/255, blue: 5/255, alpha: 1)) // zinnia
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

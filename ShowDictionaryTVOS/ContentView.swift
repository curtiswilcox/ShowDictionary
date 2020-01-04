//
//  ContentView.swift
//  ShowDictionaryTVOS
//
//  Created by Curtis Wilcox on 1/3/20.
//  Copyright © 2020 wilcoxcurtis. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var shows: [Show] = [Show(name: "Castle"), Show(name: "Doctor Who"), Show(name: "A Series of Unfortunate Events")].sorted()
    
    var body: some View {
        HStack {
            ForEach(shows) { show in
                HStack {
                    VStack {
                        Image(systemName: "photo")
                        Text(show.name)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

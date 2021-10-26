//
//  ContentView.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 10/25/21.
//  Copyright © 2021 wilcoxcurtis. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @StateObject var observer = Observer<Show>(file: "shows", language: "en")
    @State var searchText = ""
    
    private let columns: CGFloat = 3
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                let width = geometry.size.width
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: Int(columns))) {
                        ForEach($observer.items.filter({ $item in
                            searchText.isEmpty || item.name.lowercased().contains(searchText.lowercased())
                        })) { $item in
                            AsyncImage(url: item.titleCardURL) { image in
                                image.resizable()
                                    .background(.white)
                            } placeholder: {
                                ProgressView()
                                    .scaleEffect(x: 1.5, y: 1.5, anchor: .center)
                                    .background(.white)
                            }
                            .frame(width: width / (columns + 0.5), height: width / (columns + 0.5))
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(.primary, lineWidth: 2))
                            .cornerRadius(20)
                            .shadow(radius: 40)
                            .padding(.bottom)
                        }
                    }
                    .padding([.top, .horizontal])
                }
            }
            .navigationTitle("Home")
            .searchable(text: $searchText)
        }
    }
}

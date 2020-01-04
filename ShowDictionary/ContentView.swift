//
//  ContentView.swift
//  SwiftUITest
//
//  Created by Curtis Wilcox on 12/19/19.
//  Copyright © 2019 wilcoxcurtis. All rights reserved.
//

import CloudKit
import SwiftUI

struct ContentView: View {
    @ObservedObject private var observer = ShowObserver()
    @State private var searchTerm: String = "" // this is presently non-functional because not using search bar
    @State private var showingDetail: Bool = false
    @State private var shouldSpin: Bool = true
    
    var body: some View {
        ZStack {
            NavigationView {
    //            SearchBar(text: self.$searchTerm)
                List {
                    ForEach(self.getSectionHeaders(), id: \.self) { header in
                        Section(header: Text(header)) {
//                            ForEach(self.observer.data.filter {self.searchTerm.isEmpty ? true : $0.show.name.lowercased().contains(self.searchTerm.lowercased())} ) { datum in
                            ForEach(self.observer.data.filter { $0.show.firstLetter() == header }) { datum in
                                NavigationLink(destination: SearchMethodView(show: datum.show)) {
                                    HStack {
                                        TitleCardView(datum: datum)
                                        RowInfoView(datum: datum)
                                    }
                                    .contextMenu {
                                        Button(action: {
                                            self.showingDetail.toggle()
                                        }) {
                                            HStack {
                                                Text(SearchMethod.description.toString(seasonType: datum.show.typeOfSeasons))
                                                Image(systemName: "magnifyingglass")
                                            }
                                        }
                                        .sheet(isPresented: self.$showingDetail) { DescriptionView(show: datum.show) }
                                    }
                                }
                            }
                            .onAppear { self.shouldSpin = false }
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .navigationBarTitle(NSLocalizedString("home", comment: "").capitalized)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            ActivityIndicator(shouldAnimate: self.$shouldSpin)
        }
    }
    
    private func getSectionHeaders() -> [String] {
        guard !observer.data.isEmpty else { return [] }
        var headers = Set<String>()
        for datum in observer.data {
            let firstLetter = datum.show.firstLetter()
            headers.insert(firstLetter.uppercased())
        }
        return headers.sorted()
    }
}


extension ContentView {
    struct TitleCardView: View {
        var datum: ShowData
        
        var body: some View {
            ZStack {
                Rectangle()
                    .frame(width: 128.0, height: 128.0)
                    .foregroundColor(.white)
                    .border(getOption(datum.titleCard, nilOption: Color(UIColor.white), presentOption: Color(UIColor.black)), width: getOption(datum.titleCard, nilOption: 10, presentOption: 1))
                Image(uiImage: datum.titleCard ?? UIImage(systemName: "questionmark.circle")!)
                    .resizable()
                    .frame(width: 128.0, height: 128.0)
                    .border(Color(getOption(datum.titleCard, nilOption: UIColor.black, presentOption: UIColor.label)), width: 1)
            }
        }
    }
    
    struct RowInfoView: View {
        var datum: ShowData
        
        var body: some View {
            VStack(alignment: .leading) {
                Spacer()
                Text(datum.show.name)
                    .font(.headline)
                    .fontWeight(.bold)
                
                SubText("\(datum.show.numberOfSeasons) \(datum.show.typeOfSeasons.rawValue.localizeWithFormat(quantity: datum.show.numberOfSeasons))")
                
                SubText("episode".localizeWithFormat(quantity: datum.show.numberOfEpisodes))
                Spacer()
                Spacer()
                Spacer()
            }
        }
    }
}


fileprivate func getOption<T>(_ img: UIImage?, nilOption: T, presentOption: T) -> T {
    if img == nil { return nilOption }
    else { return presentOption }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .colorScheme(.light)
            ContentView()
                .colorScheme(.dark)
        }
    }
}

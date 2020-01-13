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
    @State private var shouldSpin: Bool = true
//    @State private var showMenu: Bool = false
    
    var body: some View {
        /*let drag = DragGesture()
            .onEnded {
                if $0.translation.width < -100 {
                    withAnimation { self.showMenu = false }
                } else if $0.translation.width > 100 {
                    withAnimation { self.showMenu = true }
                }
            }*/
        
        /*return */
        NavigationView {
//            GeometryReader { geometry in
            ZStack(alignment: .leading) {
                ShowListView(observer: self.observer, shouldSpin: self.$shouldSpin)//, showMenu: self.$showMenu)
//                        .frame(width: geometry.size.width, height: geometry.size.height)
//                        .offset(x: self.showMenu ? geometry.size.width / 2 : 0)
//                        .disabled(self.showMenu)
                ActivityIndicator(shouldAnimate: self.$shouldSpin)
//                        .frame(width: geometry.size.width, height: geometry.size.height)
//                        .offset(x: self.showMenu ? geometry.size.width / 2 : 0)
                /*if self.showMenu {
                    HamburgerMenuView()
                        .frame(width: geometry.size.width / 2)
                        .transition(.move(edge: .leading))
                }*/
            }
//                .gesture(drag)
            //} // weird bug below, string interpoloation fixes it
            .navigationBarTitle("\(NSLocalizedString("home", comment: "").capitalized)", displayMode: .large) // make .inline for hamburger menu time
            /*.navigationBarItems(leading: (
                Button(action: {
                    withAnimation { self.showMenu.toggle() }
                }) {
                    Image(systemName: "line.horizontal.3")
                        .imageScale(.large)
                }
            ))*/
        }
    }
}


extension ContentView {
    struct ShowListView: View {
        @ObservedObject var observer: ShowObserver
        @State var displayDescription: Bool = false
        @Binding var shouldSpin: Bool
//        @Binding var showMenu: Bool
        
        var body: some View {
//            NavigationView {
            List {
                ForEach(self.getSectionHeaders(), id: \.self) { header in
                    Section(header: Text(header)) {
                        ForEach(self.observer.data.filter { $0.show.name.firstLetter() == header }) { datum in
                            NavigationLink(destination: SearchMethodView(show: datum.show)) {
                                HStack {
                                    TitleCardView(datum: datum)
                                    RowInfoView(datum: datum)
                                }
                                .contextMenu {
                                    Button(action: {
                                        self.displayDescription.toggle()
                                    }) {
                                        HStack {
                                            Text(SearchMethod.description.toString(seasonType: datum.show.typeOfSeasons))
                                            Image(systemName: "magnifyingglass")
                                        }
                                    }
                                    .sheet(isPresented: self.$displayDescription) { DescriptionView(show: datum.show) }
                                }
                            }
                        }
                        .onAppear { self.shouldSpin = false }
                    }
                }
            }
            .listStyle(GroupedListStyle())
        
//            }
//            .navigationViewStyle(StackNavigationViewStyle())
        }
        
        private func getSectionHeaders() -> [String] {
            guard !observer.data.isEmpty else { return [] }
            var headers = Set<String>()
            for datum in observer.data {
                let firstLetter = datum.show.name.firstLetter()
                headers.insert(firstLetter.uppercased())
            }
            return headers.sorted()
        }
    }
    
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

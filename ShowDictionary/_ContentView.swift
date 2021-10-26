/*
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
	@StateObject private var observer = ShowObserver()  // was @ObservedObject... change back if hinky
	@State private var progress: CGFloat = 0
	@State var showSelected: (show: ShowData?, display: Bool) = (nil, false)
	
	var body: some View {
		NavigationView {
			ZStack {
				if let show = showSelected.show?.show {
					NavigationLink(destination: SearchMethodView().environmentObject(show), isActive: $showSelected.display) {
						EmptyView()
					}
				}
				
				if self.progress == -1 {
					VStack {
						Text(NSLocalizedString("There are no shows available for searching. Connect to the internet and try again.", comment: ""))
							.bold()
							.font(.title)
							.padding()
						Spacer()
					}
				} else {
					GridView(observer: self.observer, progress: self.$progress, showSelected: self.$showSelected)
				}
				
				if self.progress >= 0 && self.progress < self.observer.maxCount {
					ProgressView(value: self.progress, total: self.observer.maxCount)
						.progressViewStyle(LinearProgressViewStyle())
						.padding(.horizontal)
						.transformEffect(.init(scaleX: 1, y: 1.5))
				}
			}
			.navigationBarTitle("\(NSLocalizedString("home", comment: "").capitalized)", displayMode: .large)
			.onAppear {
//				guard self.progress <= self.observer.maxCount else { return }
				let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
					guard self.observer.maxCount != 0 && self.progress != self.observer.maxCount else { return }
					self.progress = CGFloat(self.observer.completion)
					if self.progress == -1 || self.progress == self.observer.maxCount {
						timer.invalidate()
					}
				}
			}
		}
	}
}

extension ContentView {
	struct GridView: View {
		@ObservedObject var observer: ShowObserver
		@Binding var progress: CGFloat
		@Binding var showSelected: (show: ShowData?, display: Bool)
		
		private let columns = 3
		
		var body: some View {
			guard progress == observer.maxCount else { return AnyView(EmptyView()) }
			return AnyView(GeometryReader { geometry in
				ScrollView {
					let headers = Set(self.observer.data.map { $0.show.sortname.first! }).map { $0.uppercased() }.sorted()
					ForEach(headers, id: \.self) { header in
						Section(header: SectionHeaderView<Text>(width: geometry.size.width) { Text(header) }) {
							LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: columns), spacing: 20) {
								let data = observer.data.filter { $0.show.sortname.uppercased().hasPrefix(header) }
								ForEach(data) { datum in
									TitleCard(datum: datum, geometry: geometry, columns: CGFloat(columns), showSelected: $showSelected)
								}
							}
							.padding(.horizontal, 5)
						}
					}
					.padding()
				}
			})
		}
	}
	
	struct TitleCard: View {
		let datum: ShowData
		let geometry: GeometryProxy
		let columns: CGFloat
		
		@State var isPressed = false
		@Binding var showSelected: (show: ShowData?, display: Bool)
		
		var body: some View {
			Button {
				isPressed.toggle()
				showSelected = (isPressed ? (datum, true) : (nil, false))
			} label: {
				ZStack {
					Rectangle()
						.foregroundColor(.white)
					if let titleCard = datum.titleCard {
						Image(uiImage: titleCard)
							.resizable()
							.accessibility(label: Text(datum.show.name))
					} else {
						Text(datum.show.name)
					}
				}
				.frame(width: geometry.size.width / (columns + 1), height: (geometry.size.width / (columns + 1)))
				.overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(datum.titleCard == nil ? .black : .label), lineWidth: 2))
				.cornerRadius(20)
			}
			.shadow(radius: 40)
			.onAppear { isPressed = false }
		}
	}
}
*/

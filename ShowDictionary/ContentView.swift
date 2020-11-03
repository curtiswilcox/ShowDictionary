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
				
				if self.progress >= 0 && self.progress < 100 {
					ProgressView(value: self.progress, total: 100)
						.progressViewStyle(LinearProgressViewStyle())
						.padding(.horizontal)
						.transformEffect(.init(scaleX: 1, y: 1.5))
				}
			}
			.navigationBarTitle("\(NSLocalizedString("home", comment: "").capitalized)", displayMode: .large)
			.onAppear {
				guard self.progress <= 100 else { return }
				let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
//					guard self.progress != -1 && !self.observer.data.isEmpty else { return }
					self.progress = self.observer.percentCompleted
					if self.progress == -1 || self.progress == 100 { timer.invalidate() }
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
			guard self.progress == 100 else { return AnyView(EmptyView()) }
			return AnyView(GeometryReader { geometry in
				ScrollView {
					LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: columns), spacing: 20) {
						ForEach(self.observer.data) { datum in
							TitleCard(datum: datum, geometry: geometry, columns: CGFloat(columns), showSelected: $showSelected)
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
				.overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(datum.titleCard == nil ? UIColor.black : UIColor.label), lineWidth: 2))
				.cornerRadius(20)
			}
			.shadow(radius: 40)
			.onAppear { isPressed = false }
		}
	}
}

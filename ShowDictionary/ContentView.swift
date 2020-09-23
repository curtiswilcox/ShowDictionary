//
//  ContentView.swift
//  SwiftUITest
//
//  Created by Curtis Wilcox on 12/19/19.
//  Copyright © 2019 wilcoxcurtis. All rights reserved.
//

import CloudKit
import SwiftUI


struct ContentGridView: View {
	@ObservedObject private var observer = ShowObserver()
	@State private var progress: CGFloat = 0
	
	var body: some View {
		NavigationView {
			ZStack {
				GridView(observer: self.observer, progress: self.$progress)
				
				if self.progress < 100 {
					ProgressView(value: self.progress, total: 100)
						.progressViewStyle(LinearProgressViewStyle())
						.padding(.horizontal)
				}
			}
			.navigationBarTitle("\(NSLocalizedString("home", comment: "").capitalized)", displayMode: .large)
			.onAppear {
				guard self.progress <= 100 else { return }
				let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
					guard !self.observer.data.isEmpty else { return }
					self.progress = self.observer.percentCompleted
					if self.progress == 100 { timer.invalidate() }
				}
			}
		}
	}
}

extension ContentGridView {
	struct GridView: View {
		@ObservedObject var observer: ShowObserver
		@Binding var progress: CGFloat
		@State var somethingIsPressed = false
		
		private let columns: Int = {
			switch (UIDevice.current.userInterfaceIdiom, UIDevice.current.orientation) {
			//    case (.pad, .portrait), (.pad, .portraitUpsideDown), (.phone, .landscapeLeft), (.phone, .landscapeRight):
			//        return 4
			//    case (.pad, .landscapeLeft), (.pad, .landscapeRight):
			//        return 5
			//    case (.phone, .portrait), (.phone, .portraitUpsideDown):
			//        return 3
			default:
				return 3 //TODO something to think about... scale effect gets wonky :(
			}
		}()
		
		var body: some View {
			guard self.progress == 100 else { return AnyView(EmptyView()) }
			return AnyView(GeometryReader { geometry in
				ScrollView {
					LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: columns), spacing: 20) {
						ForEach(0..<self.observer.data.count) { i in
							//  NavigationLink(destination: SearchMethodView(show: datum.show)) {
							TitleCard(datum: observer.data[i], geometry: geometry, columns: CGFloat(columns), column: i % 3, anotherIsPressed: $somethingIsPressed)
							//  }
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
		let column: Int
		
		@State var isPressed = false
		@Binding var anotherIsPressed: Bool
		
		var body: some View {
			Button {
//        guard !isPressed else { return }
				isPressed.toggle()
				anotherIsPressed.toggle()
			} label: {
				ZStack {
					RectListView(showing: $isPressed, datum: datum)
					Image(uiImage: datum.titleCard ?? UIImage(systemName: "questionmark.circle")!)
						.resizable()
						.opacity(isPressed ? 0 : 1)
				}
				.frame(width: geometry.size.width / (columns + 1), height: (geometry.size.width / (columns + 1)) * (isPressed ? 1.5 : 1))
				.overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(datum.titleCard == nil ? UIColor.black : UIColor.label), lineWidth: 1))
				.cornerRadius(20)
				.rotation3DEffect(isPressed ? .degrees(180) : .zero, axis: (0, 10, 0))
			}
			.offset(x: isPressed ? calcOffset(geometry, column) : 0)
			.scaleEffect(isPressed ? columns : anotherIsPressed ? 0.01 : 1)
			.opacity(isPressed ? 1 : anotherIsPressed ? 0 : 1)
			.shadow(radius: 40)
			.animation(.linear(duration: 0.6))
			.disabled(!isPressed && anotherIsPressed)
		}
		
		func calcOffset(_ geometry: GeometryProxy, _ column: Int) -> CGFloat {
			switch column {
			case 0: return geometry.size.width / 9.5
			case 1: return 0
			case 2: return -(geometry.size.width / 9.5)
			default: return 0
			}
		}
	}
}


struct RectListView: View {
	@Binding var showing: Bool
	let datum: ShowData
	
	var body: some View {
		guard showing else {
			return AnyView(Rectangle().foregroundColor(.white))
		}
		return AnyView(
			List(datum.show.getAvailableSearchMethods()) { method in
				NavigationLink(destination: Rectangle().foregroundColor(.green)) {
					Text(method.toString(seasonType: datum.show.typeOfSeasons))
				}
			}
			.rotation3DEffect(.degrees(180), axis: (0, 10, 0))
		)
	}
}



/************************************************************************************/

struct ContentView: View {
	@ObservedObject private var observer = ShowObserver()
	@State private var progress: CGFloat = 0
	
	var body: some View {
		NavigationView {
			ZStack {
				ShowListView(observer: self.observer, progress: self.$progress)
				if self.progress < 100 {
					ProgressView(value: self.progress / 100, total: 1)
						.progressViewStyle(LinearProgressViewStyle())
						.padding([.leading, .trailing])
				}
			}
			.navigationBarTitle("\(NSLocalizedString("home", comment: "").capitalized)", displayMode: .large)
			.onAppear {
				guard self.progress <= 100 else { return }
				let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
					guard !self.observer.data.isEmpty else { return }
					self.progress = self.observer.percentCompleted
					if self.progress == 100 { timer.invalidate() }
				}
			}
		}
	}
}


extension ContentView {
	struct ShowListView: View {
		@ObservedObject var observer: ShowObserver
		@State var displayDescription: Bool = false
		@Binding var progress: CGFloat
		//        @State var searchText: String = ""
		
		var body: some View {
			//            ScrollView {
			//                SearchBar(text: self.$searchText)
			guard self.progress == 100 else { return AnyView(EmptyView()) }
			return AnyView(
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
										Button(action: { self.displayDescription.toggle() }) {
											HStack {
												Text(SearchMethod.description.toString(seasonType: datum.show.typeOfSeasons))
												Image(systemName: "magnifyingglass")
											}
										}
										.sheet(isPresented: self.$displayDescription) { DescriptionView(show: datum.show) }
									}
								}
							}
						}
					}
				}
				.listStyle(GroupedListStyle())
			)
			//            }
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
	guard img != nil else { return nilOption }
	return presentOption
	//    if img == nil { return nilOption }
	//    else { return presentOption }
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

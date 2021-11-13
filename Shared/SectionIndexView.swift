// https://www.fivestars.blog/articles/section-title-index-swiftui/
//
//  SectionIndexView.swift
//  ShowDictionary (iOS)
//
//  Created by Curtis Wilcox on 11/11/21.
//

/*import SwiftUI

struct SectionIndexView: View {
    let scrollProxy: ScrollViewProxy
    let titles: [String]
    
    @GestureState private var dragLocation: CGPoint = .zero
    
    var body: some View {
        VStack {
            ForEach(titles, id: \.self) { title in
                Text(title)
                    .font(.caption)
                    .bold()
                    .foregroundColor(.blue)
                    .background(dragObserver(title: title))
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .global)
                .updating($dragLocation) { value, state, _ in
                    state = value.location
                }
        )
    }
    
    func dragObserver(title: String) -> some View {
        GeometryReader { geometry in
            dragObserver(geometry: geometry, title: title)
        }
    }
    
    func dragObserver(geometry: GeometryProxy, title: String) -> some View {
        if geometry.frame(in: .global).contains(dragLocation) {
            DispatchQueue.main.async {
                scrollProxy.scrollTo(title, anchor: .top)
            }
        }
        return Rectangle().fill(.clear)
    }
}
*/

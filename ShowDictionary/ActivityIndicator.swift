// https://github.com/programmingwithswift/SwiftUI-Activity-Indicator/tree/master/SwiftUIActivityIndicator
// December 22, 2019

import SwiftUI


struct ActivityIndicator: UIViewRepresentable {
    @Binding var shouldAnimate: Bool
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        return UIActivityIndicatorView()
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        if self.shouldAnimate {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}



















// https://jetrockets.pro/blog/activity-indicator-in-swiftui
// December 20, 2019

//import SwiftUI
//
//struct ActivityIndicator: View {
//
//    @State private var isAnimating: Bool = false
//
//    var body: some View {
//        GeometryReader { (geometry: GeometryProxy) in
//        ForEach(0..<5) { index in
//            Group {
//                Circle()
//                    .frame(width: geometry.size.width / 5, height: geometry.size.height / 5)
//                    .scaleEffect(!self.isAnimating ? 1 - CGFloat(index) / 5 : 0.2 + CGFloat(index) / 5)
//                    .offset(y: geometry.size.width / 10 - geometry.size.height / 2)
//            }.frame(width: geometry.size.width, height: geometry.size.height)
//                .rotationEffect(!self.isAnimating ? .degrees(0) : .degrees(360))
//                .animation(Animation
//                .timingCurve(0.5, 0.15 + Double(index) / 5, 0.25, 1, duration: 1.5)
//                .repeatForever(autoreverses: false))
//            }
//        }
//        .aspectRatio(1, contentMode: .fit)
//        .onAppear {
//            self.isAnimating = true
//        }
//    }
//}

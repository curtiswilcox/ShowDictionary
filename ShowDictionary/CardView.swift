//
//  SwiftUIView.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 10/5/20.
//  Copyright © 2020 wilcoxcurtis. All rights reserved.
//

import SwiftUI


struct CardView<Content: View>: View {
  let width: CGFloat
  let vertAlignment: VerticalAlignment
  let horizAlignment: HorizontalAlignment
  let content: Content
  
  init(width: CGFloat, vertAlignment: VerticalAlignment = .center, horizAlignment: HorizontalAlignment = .leading, @ViewBuilder content: () -> Content) {
    self.width = width
    self.vertAlignment = vertAlignment
    self.horizAlignment = horizAlignment
    self.content = content()
  }
    var body: some View {
      ZStack {
        RoundedRectangle(cornerRadius: 20)
          .stroke(Color(UIColor.label), lineWidth: 2)
          .frame(width: width)
          .padding([.horizontal])
        HStack(alignment: vertAlignment) {
          VStack(alignment: horizAlignment) {
            content
          }
          Spacer()
        }
        .frame(width: abs(width - 20))
        .frame(minHeight: (width / 2) - 20)
      }
    }
}

//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView()
//    }
//}

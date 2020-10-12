//
//  SectionHeaderView.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 10/11/20.
//  Copyright © 2020 wilcoxcurtis. All rights reserved.
//

import SwiftUI


struct SectionHeaderView<Content: View>: View {
  let width: CGFloat
  let text: Text
  
  init(width: CGFloat, @ViewBuilder text: () -> Text) {
    self.width = width
    self.text = text()
  }
  var body: some View {
    VStack(alignment: .leading) {
      Divider()
        .background(Color.gray)
        .offset(x: width / (UIDevice.current.userInterfaceIdiom == .pad ? 40 : 24))
      text
        .font(.title)
        .bold()
        .padding(.leading)
    }
    .padding(.top)
  }
}

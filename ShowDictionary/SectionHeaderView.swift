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
        .frame(minWidth: width)
        .background(Color.gray)
      HStack {
        text
          .font(.title)
          .bold()
          .padding(.trailing, width / 8)
      }
    }
    .padding(.top)
    .padding(.leading, width / 8)
  }
}

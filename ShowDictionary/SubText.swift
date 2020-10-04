//
//  SubText.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 12/30/19.
//  Copyright © 2019 wilcoxcurtis. All rights reserved.
//

import SwiftUI

struct SubText<S: StringProtocol>: View {
  let content: S
  
  var body: some View {
    #if os(iOS)
    Text(content)
      .font(.subheadline)
      .foregroundColor(Color(UIColor.systemGray))
    #elseif os(watchOS)
    Text(content)
      .font(.subheadline)
      .foregroundColor(Color(UIColor.gray))
    #endif
  }
  
  init(_ content: S) {
    self.content = content
  }
}

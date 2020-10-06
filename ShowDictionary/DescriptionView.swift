//
//  DescriptionView.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 12/20/19.
//  Copyright © 2019 wilcoxcurtis. All rights reserved.
//

import SwiftUI

struct DescriptionView: View {
  let show: Show
  var body: some View {
    ScrollView {
      VStack {
        Text(show.description)
          .lineSpacing(10)
          .padding(.all, 20)
          .fixedSize(horizontal: false, vertical: true)
      }
    }
    .navigationBarTitle(String(format: NSLocalizedString("%@ Description", comment: "description of the show"), self.show.name))
  }
}

struct DescriptionView_Previews: PreviewProvider {
  static var previews: some View {
    DescriptionView(show: Show(name: "test"))
  }
}

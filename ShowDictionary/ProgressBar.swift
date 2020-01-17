//
//  ProgressBar.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 1/16/20.
//  Copyright © 2020 wilcoxcurtis. All rights reserved.
//

// https://rscodesios.wordpress.com/2019/07/23/creating-a-progressbar-in-swiftui/

import SwiftUI

struct ProgressBar: View {
    @Binding var progress: CGFloat
 
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color(UIColor.secondaryLabel))
                    .opacity(0.3)
                    .frame(width: geometry.size.width - 20, height: 8.0)
                Rectangle()
                    .foregroundColor(Color(UIColor.systemBlue))
                    .frame(width: (geometry.size.width - 20) * (self.progress / 100), height: 8.0)
                    .animation(.linear(duration: 0.6))
            }
            .cornerRadius(4.0)
        }
    }
}

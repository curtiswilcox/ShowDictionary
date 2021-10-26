//
//  SubText.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 12/30/19.
//  Copyright © 2019 wilcoxcurtis. All rights reserved.
//

import SwiftUI

struct Subtext: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .foregroundColor(.gray)
    }
}

extension Text {
    func subtext() -> some View {
        modifier(Subtext())
    }
}

//
//  CircledNumber.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 10/28/21.
//

import SwiftUI

struct CircledNumber: View {
    let number: Int
    
    var body: some View {
        Text("\(number)")
            .font(.footnote)
            .overlay(Image(systemName: "circle"))
            .foregroundColor(.primary)
    }
}

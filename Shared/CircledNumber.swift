//
//  CircledNumber.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 10/28/21.
//

import SwiftUI

struct CircledNumber: View {
    let number: Int
    let force: Bool
    
    private let maxNum = 50
    
    var body: some View {
        if number <= maxNum {
            Image(systemName: "\(number).circle")
        } else if force {
            Text("\(number)")
                .font(.footnote)
                .overlay(Image(systemName: "circle"))
                .foregroundColor(.primary)
        } else {
            Image(systemName: "questionmark.circle")
        }
    }
}

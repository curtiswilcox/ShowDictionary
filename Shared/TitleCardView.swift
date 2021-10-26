//
//  TitleVardView.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 10/26/21.
//  Copyright © 2021 wilcoxcurtis. All rights reserved.
//

import SwiftUI

struct TitleCardView: View {
    @Binding var show: Show
    
    let width: CGFloat
    let columns: CGFloat
    
    var body: some View {
        AsyncImage(url: show.titleCardURL) { image in
            image.resizable()
        } placeholder: {
            ProgressView()
                .scaleEffect(x: 1.5, y: 1.5, anchor: .center)
        }
        .background(.white)
        .frame(width: width / (columns + 0.5), height: width / (columns + 0.5))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(.primary, lineWidth: 2))
        .cornerRadius(20)
        .shadow(radius: 40)
        .padding(.bottom)
    }
}

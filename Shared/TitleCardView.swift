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
        AsyncImage(url: show.titleCardURL) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .background(.white)
                    .task {
                        await show.saveImage()
                    }
            } else { // placeholder or error
                if let savedImage = try? UIImage(data: show.getImage()) {
                    Image(uiImage: savedImage)
                } else {
                    ProgressView()
                        .scaleEffect(x: 1.5, y: 1.5, anchor: .center)
                        .background(.clear)
                }
            }
        }
        .frame(width: width / (columns + 0.5), height: width / (columns + 0.5))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(.primary, lineWidth: 2))
        .cornerRadius(20)
        .shadow(radius: 40)
        .padding(.bottom)
    }
}

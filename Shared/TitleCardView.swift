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
                #if os(iOS)
                if let savedImage = try? UIImage(data: show.getSavedImage()) {
                    Image(uiImage: savedImage)
                        .resizable()
                        .background(.white)
                } else {
                    spinner
                }
                #elseif os(macOS)
                spinner
                #endif
            }
        }
        .frame(width: 100, height: 100)
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(.primary, lineWidth: 2))
        .cornerRadius(15)
        .padding(.vertical, 5)
    }
    
    var spinner: some View {
        ProgressView()
            .scaleEffect(x: 1.5, y: 1.5, anchor: .center)
            .background(.clear)
    }
}

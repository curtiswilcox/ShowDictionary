//
//  TestView.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 1/13/20.
//  Copyright © 2020 wilcoxcurtis. All rights reserved.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    HStack {
                        Text(String(repeating: "Lorem ipsum. ", count: 90))
                            .lineSpacing(10)
                            .padding(.all, 20)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                }
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "star.fill")
                    }
                    .padding()
                    
                    Button(action: {}) {
                        Image(systemName: "info.circle")
                    }
                    .padding()
                }
            }
            .navigationBarTitle("Lorem Ipsum")
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}

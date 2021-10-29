//
//  LoaderView.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 10/26/21.
//  Copyright © 2021 wilcoxcurtis. All rights reserved.
//

import SwiftUI

struct LoaderView<T: Observable, InnerView: View>: View {
    @ObservedObject var observer: Observer<T>
    
    @State private var loading = true
    
    @State private var loadFailure = false
    @State private var loadFailureMessage: String?
    @State private var loadAgain = false
    
    @ViewBuilder let innerView: () -> (InnerView)
    
    var body: some View {
        ZStack {
            innerView()
                .opacity(loading ? 0 : 100)
            
            if loading {
                ProgressView()
                    .scaleEffect(x: 1.5, y: 1.5)
            }
        }
        .alert(loadFailureMessage ?? "Error", isPresented: $loadFailure) {
            Button("Try again", role: .none) {
                loadAgain.toggle()
            }
        }
        .task(id: loadAgain, priority: .high) {
            guard observer.items.isEmpty else { return }
            loading = true
            do {
                try await observer.summon()
                loading = false
            } catch let e {
                loadFailure = true
                loadFailureMessage = "Error: \(e.localizedDescription)"
            }
        }
    }
}

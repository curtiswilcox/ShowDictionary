//
//  View+if.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 10/28/21.
//

import SwiftUI

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    @ViewBuilder func `if`<TrueContent: View, FalseContent: View>(_ condition: Bool, if ifTransform: (Self) -> TrueContent, else elseTransform: (Self) -> FalseContent) -> some View {
        if condition {
            ifTransform(self)
        } else {
            elseTransform(self)
        }
    }
}
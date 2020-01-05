//
//  TesterView.swift
//  ShowDictionaryWatchOS Extension
//
//  Created by Curtis Wilcox on 1/4/20.
//  Copyright © 2020 wilcoxcurtis. All rights reserved.
//

import SwiftUI

struct TesterView: View {
    let list = ["This", "is", "a", "list"]
    
    var body: some View {
        List {
            ForEach(1...4, id: \.self) { num in
                Section(header: Text("Section \(num)")) {
                    Text(self.list[num - 1])
                }
            }
        }
    }
}

struct TesterView_Previews: PreviewProvider {
    static var previews: some View {
        TesterView()
    }
}

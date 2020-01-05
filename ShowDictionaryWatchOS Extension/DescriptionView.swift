//
//  DescriptionView.swift
//  ShowDictionaryWatchOS Extension
//
//  Created by Curtis Wilcox on 1/4/20.
//  Copyright © 2020 wilcoxcurtis. All rights reserved.
//

import Foundation
import SwiftUI


struct DescriptionView: View {
    let show: Show
    
    var body: some View {
        ScrollView {
            Text(show.description)
                .navigationBarTitle(String(format: NSLocalizedString("%@ Description", comment: ""), self.show.name))
        }
    }
}

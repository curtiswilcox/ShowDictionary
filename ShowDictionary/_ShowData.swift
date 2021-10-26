/*
//
//  ShowData.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 1/4/20.
//  Copyright © 2020 wilcoxcurtis. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit.UIImage

class ShowData : Comparable, Identifiable {
    let show: Show
    let titleCard: UIImage?
    
    init(_ show: Show, _ titleCard: UIImage? = nil) {
        self.show = show
        self.titleCard = titleCard
    }
    
    static func < (lhs: ShowData, rhs: ShowData) -> Bool {
        return lhs.show < rhs.show
    }
    
    static func == (lhs: ShowData, rhs: ShowData) -> Bool {
        return lhs.show == rhs.show
    }
}

*/

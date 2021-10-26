//
//  Int+toWord.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 10/29/20.
//  Copyright © 2020 wilcoxcurtis. All rights reserved.
//

import Foundation

extension Int {
  func toWord() -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    return formatter.string(from: NSNumber(value: self))!
  }
}

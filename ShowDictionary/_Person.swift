/*
//
//  Person.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 1/11/20.
//  Copyright © 2020 wilcoxcurtis. All rights reserved.
//

import Foundation

struct Person: Comparable, Codable, Hashable, Identifiable {
  let fullName: String
  
  var lastName: String {
    String(fullName.split(separator: "(")[0].split(separator: " ").last!)
  }
  
  var id: String { fullName }
  
  
  static func < (lhs: Person, rhs: Person) -> Bool {
    if lhs.lastName.lowercased() == rhs.lastName.lowercased() {
      return lhs.fullName.lowercased() < rhs.fullName.lowercased()
    }
    return lhs.lastName.lowercased() < rhs.lastName.lowercased()
  }
  
  static func == (lhs: Person, rhs: Person) -> Bool {
    return lhs.fullName.lowercased() == rhs.fullName.lowercased()
  }
}

*/

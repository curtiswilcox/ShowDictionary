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
    
    var lastName: String { String(fullName.split(separator: " ").last!) }
    var id: String { fullName }
    
    init(name: String) {
        self.fullName = name
//        let toReplace = ["of", "the", "a"]
//
//        let split = name.split(separator: " ").map { String($0) }
//
//        if split.count >= 3 {
//            firstName = split[0]
//            middleName = split[1]
//            lastName = split.dropFirst(2).joined(separator: " ")
//        } else if split.count == 2 {
//            firstName = split[0]
//            middleName = nil
//            lastName = split[1]
//        } else {
//            firstName = nil
//            middleName = nil
//            lastName = split[0]
//        }
    }
    
//    func getName() -> String {
//        return "\(firstName == nil ? "" : " \(firstName!)")\(middleName == nil ? "" : " \(middleName!)") \(lastName)"
//    }
    
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


//
//  Person.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 10/28/21.
//

import Foundation

struct Person: Comparable, CustomStringConvertible, Hashable, Identifiable {
    let id = UUID()
    
    let firstName: String
    let middleName: String?
    let lastName: String
    
    var description: String {
        fullName
    }
    
    var fullName: String {
        "\(firstName)\(middleName != nil ? " \(middleName!)" : "") \(lastName)"
    }
    
    init(firstName: String, middleName: String? = nil, lastName: String) {
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
    }
    
    init(fullName: String) throws {
        let parts = fullName.split(separator: " ").map { String($0) }
        if parts.count == 1 {
            throw NameError.onlyOneName("The name \(fullName) is not enough to create a person -- a first and last name are both required (a middle name is optional)")
        } else if parts.count == 2 {
            self.firstName = parts[0]
            self.lastName = parts[1]
            self.middleName = nil
        } else {
            self.firstName = parts[0]
            self.middleName = parts[1]
            self.lastName = parts.dropFirst(2).joined(separator: " ")
        }
    }
    
    static func <(lhs: Person, rhs: Person) -> Bool {
        if lhs.lastName != rhs.lastName {
            return lhs.lastName < rhs.lastName
        }
        
        if lhs.firstName != rhs.firstName || (lhs.middleName == nil && rhs.middleName == nil) {
            return lhs.firstName < rhs.firstName
        }
        
        if lhs.middleName == nil && rhs.middleName != nil {
            return true
        }
        
        if lhs.middleName != nil && rhs.middleName == nil {
            return false
        }
        
        return lhs.middleName! < rhs.middleName!
    }
    
    static func ==(lhs: Person, rhs: Person) -> Bool {
        lhs.fullName == rhs.fullName
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(fullName)
    }
}

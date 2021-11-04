//
//  Person.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 10/28/21.
//

import Foundation

struct Person: Comparable, CustomStringConvertible, Hashable, Identifiable {
    let id = UUID()
    
    let firstName: String?
    let middleName: String?
    let lastName: String
    
    var description: String {
        fullName
    }
    
    var fullName: String {
        "\(firstName != nil ? "\(firstName!) " : "")\(middleName != nil ? "\(middleName!) " : "")\(lastName)".trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    init(firstName: String, middleName: String? = nil, lastName: String) {
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
    }
    
    init(fullName name: String) throws {
        let parts = name.split(separator: " ").map { String($0) }
        if parts.count == 1 {
            self.firstName = nil
            self.middleName = nil
            self.lastName = name
//            throw NameError.onlyOneName("The name \(name) is not enough to create a person -- a first and last name are both required (a middle name is optional)")
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
        if lhs.lastName.alphanumeric() != rhs.lastName.alphanumeric() {
            return String(lhs.lastName.split(separator: " ").last!).alphanumeric() < String(rhs.lastName.split(separator: " ").last!).alphanumeric()
        }
        
        if lhs.firstName != rhs.firstName {
            if let lhsFirst = lhs.firstName?.alphanumeric(), let rhsFirst = rhs.firstName?.alphanumeric() {
                return lhsFirst < rhsFirst
            }
            if lhs.firstName?.alphanumeric() != nil, rhs.firstName == nil {
                return true
            }
            return false
        }
        
        if lhs.middleName == nil && rhs.middleName != nil {
            return true
        }
        
        if lhs.middleName != nil && rhs.middleName == nil {
            return false
        }
        
        return lhs.middleName!.alphanumeric() < rhs.middleName!.alphanumeric()
    }
    
    static func ==(lhs: Person, rhs: Person) -> Bool {
        lhs.fullName == rhs.fullName
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(fullName)
    }
}

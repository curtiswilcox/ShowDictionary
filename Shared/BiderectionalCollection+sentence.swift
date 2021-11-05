//
//  BiderectionalCollection+sentence.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 11/2/21.
//
// https://stackoverflow.com/questions/41819086/join-string-array-with-separator-and-add-and-to-join-the-last-element


import Foundation

extension BidirectionalCollection where Element: StringProtocol {
    var sentence: String {
        let and = String(localized: "and")
        return count <= 2 ?
        joined(separator: " \(and) ") :
        dropLast().joined(separator: ", ") + ", \(and) " + last!
    }
}

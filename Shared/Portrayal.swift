//
//  Portrayal.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 10/28/21.
//

import Foundation

struct Portrayal: CustomStringConvertible, Comparable, Hashable, Identifiable {
    let id = UUID()
    let character: Person
    let actor: Person
    let appearances: [Int]
    
    var description: String {
        "\(actor) as \(character)"
    }
    
    var attributed: AttributedString {
        try! AttributedString(markdown: "\(actor) *as* \(character)")
    }
    
    func isIn(episode code: Int) -> Bool {
        appearances.contains(code)
    }
    
    func isIn(episode: Episode) -> Bool {
        isIn(episode: episode.code)
    }
    
    static func <(lhs: Portrayal, rhs: Portrayal) -> Bool {
        lhs.character < rhs.character
    }
    
    static func ==(lhs: Portrayal, rhs: Portrayal) -> Bool {
        lhs.character == rhs.character && lhs.actor == rhs.actor
    }
}

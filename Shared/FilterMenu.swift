//
//  FilterMenu.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 11/3/21.
//

import SwiftUI

typealias Filterable = Comparable & CustomStringConvertible & Hashable & Identifiable

struct FilterMenu<P: Filterable>: View {
    @Binding var people: [P: (count: Int, valid: Bool)]!
    let type: String
    
    @Binding var current: [P]?
    
    var body: some View {
        Menu {
            Section {
                Button(role: .destructive) {
                    withAnimation {
                        current = nil
                    }
                } label: {
                    if current != nil {
                        Text("Clear active \(type) filter\(current!.count > 1 ? "s" : "")")
                    } else {
                        Text("No active filters")
                    }
                }
                .disabled(current == nil)
            }
            
            ForEach(people.keys.sorted(by: { (lhs, rhs) in
                if current != nil && (current!.contains(lhs) || current!.contains(rhs)) {
                    if current!.contains(lhs) && current!.contains(rhs) {
                        return lhs < rhs
                    } else {
                        return current!.contains(lhs)
                    }
                } else if people[lhs]!.valid != people[rhs]!.valid {
                    return people[lhs]!.valid
                } else {
                    return lhs < rhs
                }
            })) { person in
                Button {
                    withAnimation {
                        if current == nil {
                            current = [person]
                        } else if !current!.contains(person) {
                            current?.append(person)
                        } else {
                            current?.removeAll { $0 == person }
                            if current!.isEmpty {
                                current = nil
                            }
                        }
                    }
                } label: {
                    Text(person.description)
                    Spacer()
                    if current?.contains(person) ?? false {
                        Image(systemName: "checkmark")
                            .foregroundColor(.primary)
                    } else if let (count, _) = people[person] {
                        CircledNumber(number: count, force: false)
                            .foregroundColor(.primary)
                    }
                }
                .disabled(!people[person]!.valid)
            }
        } label: {
            Label("Filter by \(type)", systemImage: "checkmark")
                .if(current == nil) {
                    $0.labelStyle(.titleOnly)
                } else: {
                    $0.labelStyle(.titleAndIcon)
                }
        }
    }
}

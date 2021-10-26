//
//  Observer.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 10/25/21.
//  Copyright © 2021 wilcoxcurtis. All rights reserved.
//

import Foundation

class Observer<T: Observable>: ObservableObject {
    @Published var items = [T]()
    
    private let file: String
    private let language: String
    
    init(file: String, language: String) {
        self.file = file
        self.language = language
        
        Task {
            do {
                try await summon()
//                print(items)
            } catch let e {
                print(e)
            }
        }
    }
    
    @MainActor
    func summon() async throws {
        let (data, _) = try await URLSession.shared.data(from: formURL())
        self.items = (try JSONDecoder().decode([T].self, from: data)).sorted()
    }
    
    private func formURL() -> URL {
        URL(string: "http://3.13.104.19/show-dictionary/files/\(file)_\(language).json")!
    }
}

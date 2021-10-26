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
    
    private(set) var file: String?
    private(set) var language: String?
    
    init() {
        file = nil
        language = nil
    }
    
    init(file: String, language: String) {
        self.file = file
        self.language = language
    }
    
    func update(file: String, language: String) {
        self.file = file
        self.language = language
    }
    
    @MainActor
    func summon() async throws {
        let (data, _) = try await URLSession.shared.data(from: formURL())
        self.items = (try JSONDecoder().decode([T].self, from: data)).sorted()
    }
    
    private func formURL() -> URL {
        guard let file = file, let language = language else {
            return URL("google.com") // FIXME: this is stupid, fix it
        }
        return URL(string: "http://3.13.104.19/show-dictionary/files/\(file)_\(language).json")!
    }
}

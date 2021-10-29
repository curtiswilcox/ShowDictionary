//
//  Observer.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 10/25/21.
//  Copyright © 2021 wilcoxcurtis. All rights reserved.
//

import CloudKit
import Foundation

class Observer<T: Observable>: ObservableObject {
    @Published var items = [T]()
    
    private(set) var file: String?
    private(set) var language: String?
    
    private let container = CKContainer(identifier: "iCloud.wilcoxcurtis.ShowDictionary").privateCloudDatabase

    private var favorites: [Int: CKRecord.ID]?
    
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
        async let (data, _) = try URLSession.shared.data(from: formURL())
        let favorites = try await getFavorites()
        
        self.favorites = favorites?.reduce(into: [:]) { (result, entry) in
            result[entry.code] = entry.recordID
        }
        
        self.items = try JSONDecoder().decode([T].self, from: await data).sorted().map {
            guard var episode = $0 as? Episode else { return $0 }
            if favorites?.map(\.code).contains(episode.code) ?? false {
                episode.isFavorite = true
            }
            return episode as! T
        }
    }
    
    private func formURL() throws -> URL {
        guard let file = file, let language = language else {
            throw URLError.malformedURL("Could not form URL with arguments (file: `\(file ?? "nil")`, language: `\(language ?? "nil")`).")
        }
        return URL(string: "http://3.13.104.19/show-dictionary/files/\(file)_\(language).json")!
    }
    
    private func getFavorites() async throws -> [Record]? {
        // FIXME: these aren't working properly. not syncing to database?
        guard signedIn, file != nil else { return nil }
        
        let query: CKQuery = {
            let query = CKQuery(recordType: "episodes", predicate: NSPredicate(format: "filename == %@", file!))
            query.sortDescriptors = [NSSortDescriptor(key: "code", ascending: true)]
            return query
        }()
        
        let keys = ["filename", "code"]
        
        var (records, cursor) = try await container.records(matching: query, desiredKeys: keys)
        
        while cursor != nil {
            let (rs, c) = try await container.records(continuingMatchFrom: cursor!, desiredKeys: keys)
            records.append(contentsOf: rs)
            cursor = c
        }
                    
        guard !records.isEmpty else { return nil }
        
        let favorites: [Record] = try records.compactMap { (id, result) in
            let record = try result.get()
            
            if let filename = record.getString(field: "filename"),
               let code = record.getInt(field: "code") {
                return (id, filename, code)
            } else {
                return nil
            }
        }

        return favorites.isEmpty ? nil : favorites
    }
    
    func toggleFavorite(to favorite: Bool, code episode: Int) throws {
        guard signedIn, file != nil && file != "shows" else { return }
        
        Task {
            if favorite {
                try await addFavorite(for: episode)
            } else {
                try await removeFavorite(for: episode)
            }
        }
    }
    
    private func addFavorite(for episode: Int) async throws {
        let record: CKRecord = {
            let record = CKRecord(recordType: "episodes")
            record["filename"] = file! // can safely do this because `toggleFavorite`
            record["code"] = episode
            return record
        }()
        
        self.favorites?[episode] = record.recordID
        
        try await container.save(record)
    }
    
    private func removeFavorite(for episode: Int) async throws {
        guard let id = self.favorites?[episode] else { return }

        try await container.deleteRecord(withID: id)
    }
}
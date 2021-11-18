//
//  ShowObserver.swift
//  ShowDictionary (iOS)
//
//  Created by Curtis Wilcox on 11/17/21.
//

import CloudKit
import Foundation

final class ShowObserver: Observer {
    typealias T = Show
    typealias RecordType = String
    
    @Published var items = [Show]()
    private(set) var file: String?
    let language = Locale.current.languageCode
    
    let container = CKContainer(identifier: "iCloud.wilcoxcurtis.ShowDictionary").privateCloudDatabase
    
    init() {
        self.file = "shows"
    }
        
    @MainActor
    func summon() async throws {
        let (data, _) = try await URLSession.shared.data(from: formURL())
        
        let favoriteShows = try? await getFavorites()
        
        self.items = try JSONDecoder().decode([T].self, from: data).sorted().map {
            var show = $0
            if let favoriteShows = favoriteShows, favoriteShows.contains(show.filename) {
                show.hasFavoriteEpisodes = true
            }
            return show
        }
    }
    
    func formURL() throws -> URL {
        guard let file = file, let language = language else {
            throw URLError.malformedURL(String(localized: "Could not form URL with arguments (file: `\(file ?? "nil")`, language: `\(language ?? "nil")`)."))
        }
        return URL(string: "http://3.13.104.19/show-dictionary/files/\(file)_\(language).json")!
    }
    
    func formQuery(predicate: NSPredicate, sortKey: String?) -> CKQuery {
        let query = CKQuery(recordType: "episodes", predicate: predicate)
        if let sortKey = sortKey {
            query.sortDescriptors = [NSSortDescriptor(key: sortKey, ascending: true)]
        }
        return query
    }
    
    func getRecords(query: CKQuery, desiredKeys: [String]) async throws -> [(CKRecord.ID, Result<CKRecord, Error>)]? {
        var (records, cursor) = try await container.records(matching: query, desiredKeys: desiredKeys)
        
        while cursor != nil {
            let (rs, c) = try await container.records(continuingMatchFrom: cursor!, desiredKeys: desiredKeys)
            records.append(contentsOf: rs)
            cursor = c
        }
                    
        return records
    }
    
    func getFavorites() async throws -> [String]? {
        guard signedIn else { return nil }
        
        let query = formQuery(predicate: NSPredicate(value: true), sortKey: "filename")
        
        let keys = ["filename"]
        
        guard let records = try await getRecords(query: query, desiredKeys: keys) else {
            return nil
        }
        
        let favoriteShows: [String] = try records.compactMap { (id, result) in
            let record = try result.get()
            
            if let filename = record.getString(field: "filename") {
               return filename
            } else {
                return nil
            }
        }

        return favoriteShows.isEmpty ? nil : favoriteShows
    }

}

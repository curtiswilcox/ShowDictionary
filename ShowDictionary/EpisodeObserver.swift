//
//  EpisodeObserver.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 1/7/20.
//  Copyright © 2020 wilcoxcurtis. All rights reserved.
//

import Alamofire
import CloudKit
import Foundation

class EpisodeObserver : ObservableObject {
    private var showname: String
    private var records: [Record] = []

    init(_ showname: String) {
        self.showname = showname // really the filename
    }

    func getEpisodes(completion: @escaping ([Episode], Bool) -> ()) {
        var episodes: [Episode] = []
        Alamofire.request("https://wilcoxcurtis.com/show-dictionary/files/\(self.showname)_\(Locale.current.languageCode ?? "en").json", method: .get).responseString() { response in

            switch response.result {
            case .success(var text):
                text = text.replacingOccurrences(of: "<pre>", with: "").replacingOccurrences(of: "</pre>", with: "").trimmingCharacters(in: .whitespacesAndNewlines) // remove the pretty-print tags from HTML
                do {
                    let decoder = JSONDecoder()
                    episodes = try decoder.decode([Episode].self, from: Data(text.utf8)).sorted(by: <)
                    self.queryFavoritism(episodes) { (episodes, hasFaves) in
//                        for episode in episodes where episode.isFavorite { print(episode) }
                        completion(episodes, hasFaves)
                    }
                } catch {
                    completion([], false)
                }
            case .failure:
                completion([], false)
            }
        }
    }
    
    private func queryFavoritism(_ episodes: [Episode], completion: @escaping ([Episode], Bool) -> Void) {
        guard signedIn else { completion(episodes, false); return }
        
        let database = CKContainer(identifier: "iCloud.wilcoxcurtis.ShowDictionary").privateCloudDatabase
        let query = CKQuery(recordType: "episodes", predicate: NSPredicate(value: true))
        let operation = CKQueryOperation(query: query)
        operation.qualityOfService = .userInitiated
        operation.desiredKeys = ["filename", "code"]
        operation.recordFetchedBlock = getFavorites
        operation.queryCompletionBlock = { cursor, error in
            if let cursor = cursor {
                self.fetchRecords(cursor) {
                    DispatchQueue.main.async {
                        var hasFaves = false
                        if let error = error { print(error) } else {
                            for rec in self.records {
                                for episode in episodes where
                                    self.showname == rec.filename && episode.code == Int(rec.code) {
                                        episode.isFavorite = true
                                        episode.favoritedID = rec.id
                                        hasFaves = true
                                }
                            }
                        }
                        completion(episodes, hasFaves)
                    }
                }
            } else {
                completion(episodes, false)
            }
        }
        database.add(operation)
    }
    
    private func fetchRecords(_ cursor: CKQueryOperation.Cursor?, completion: @escaping () ->Void) {
        let database = CKContainer(identifier: "iCloud.wilcoxcurtis.ShowDictionary").privateCloudDatabase
        let operation = CKQueryOperation(cursor: cursor!)
        operation.qualityOfService = .userInitiated
        operation.desiredKeys = ["filename", "code"]
        operation.recordFetchedBlock = getFavorites
        operation.queryCompletionBlock = { cursor, error in
            if let cursor = cursor {
                self.fetchRecords(cursor, completion: completion)
            } else {
                completion()
            }
        }
        database.add(operation)
    }
    
    private func getFavorites(_ record: CKRecord) {
        let code = String(format: "%@", record["code"]! as! CVarArg)
        records.append(Record(code: code, filename: record["filename"]!, id: record.recordID))
    }
    
}

struct Record {
    let code: String
    let filename: String
    let id: CKRecord.ID
}

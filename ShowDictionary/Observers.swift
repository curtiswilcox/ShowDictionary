//
//  Observers.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 12/19/19.
//  Copyright © 2019 wilcoxcurtis. All rights reserved.
//

import Alamofire
import CloudKit
import Foundation
import UIKit.UIImage

class ShowObserver : ObservableObject {
    @Published var loaded: Bool = false
    var data: [ShowData] = []

    init() {
        getShows() { shows in
            for show in shows {
                URLSession(configuration: .default).dataTask(with: show.titleCardURL, completionHandler: { (data, response, error) in
                    DispatchQueue.main.async {
                        if let imageData = data, let img = UIImage(data: imageData) {
                            self.data.append(ShowData(show, img))
                        } else {
                            self.data.append(ShowData(show)) // img is nil
                        }
                        self.data.sort(by: <)
                        if shows.count == self.data.count {
                            self.loaded = true
                        }
                    }
                }).resume()
            }
        }
    }

    func getShows(completion: @escaping ([Show]) -> ()) {
        var shows: [Show] = []

        Alamofire.request("https://wilcoxcurtis.com/show-dictionary/files/shows_\(Locale.current.languageCode ?? "en").json", method: .get, encoding: JSONEncoding.prettyPrinted).responseJSON() { response in

            switch response.result {
            case .success(let text):
                let jsonString = (text as! [[String: Any]]).toJSONString()
                do {
                    let decoder = JSONDecoder()
                    shows = try decoder.decode([Show].self, from: Data(jsonString.utf8)).sorted(by: <)
                    shows = shows.sorted(by: <)
                    completion(shows)
//                    self.findFavoritedShows() { favs in
//                        print(shows)
//                        guard !shows.isEmpty else { return }
//                        shows = shows.sorted(by: <)
//                        for show in shows where favs?.contains(show.filename) ?? false {
//                            show.hasFavoritedEpisodes = true
//                        }
//                        print(shows)
//                        completion(shows)
//                    }
                } catch {
                    completion([])
                }
            case .failure:
                completion([])
            }
        }
    }
    
    /*
    func findFavoritedShows(completion: @escaping (Set<String>?) -> Void) {
        guard signedIn else {
//            print("iCloud account not available!")
            completion(nil)
            return
        }
                
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "episodes", predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["filename"]
        
        var records = Set<String>()
        operation.recordFetchedBlock = { record in
            let filename = String(record["filename"]!)
            records.insert(filename)
        }
        operation.queryCompletionBlock = { (cursor, error) in
            if let cursor = cursor {
                let newOperation = CKQueryOperation(cursor: cursor)
                newOperation.recordFetchedBlock = operation.recordFetchedBlock
                newOperation.queryCompletionBlock = operation.queryCompletionBlock
                CKContainer(identifier: "iCloud.wilcoxcurtis.ShowDictionary").privateCloudDatabase.add(newOperation)
            } else {
                DispatchQueue.main.async {
                    print(records)
                    guard error == nil else {
                        print(error!)
                        completion(nil)
                        return
                    }
                    completion(records)
                }
            }
        }
        CKContainer(identifier: "iCloud.wilcoxcurtis.ShowDictionary").privateCloudDatabase.add(operation)
    }
 */
}


class EpisodeObserver : ObservableObject {
    private var showname: String
    private var records: [String] = []

    init(_ showname: String) {
        self.showname = showname // really the filename
    }

    func getEpisodes(completion: @escaping ([Episode], Bool) -> ()) {
        var episodes: [Episode] = []
        Alamofire.request("https://wilcoxcurtis.com/show-dictionary/files/\(self.showname)_\(Locale.current.languageCode ?? "en").json", method: .get, encoding: JSONEncoding.prettyPrinted).responseJSON() { response in

            switch response.result {
            case .success(let text):
                let jsonString = (text as! [[String: Any]]).toJSONString()
                do {
                    let decoder = JSONDecoder()
                    episodes = try decoder.decode([Episode].self, from: Data(jsonString.utf8)).sorted(by: <)
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
        guard signedIn else { return }
        
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
                                    self.showname == String(rec.split(separator: "+")[0]) &&
                                    episode.code == Int(rec.split(separator: "+")[1]) {
                                        episode.isFavorite = true
                                        hasFaves = true
                                }
                            }
                        }
                        completion(episodes, hasFaves)
                    }
                }
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
        records.append("\(record["filename"]!)+\(code)")
    }
    
}

func updateServerEpisodeIsFavorite(filename show: String, code: Int) {
    guard signedIn else { /*print("iCloud account not available!"); */return }
        let episodeRecord = CKRecord(recordType: "episodes")
        episodeRecord["filename"] = show
        episodeRecord["code"] = code
        CKContainer(identifier: "iCloud.wilcoxcurtis.ShowDictionary").privateCloudDatabase.save(episodeRecord) { (record, error) in
            if let error = error {
                print("Problem updating favorite episode: \(error.localizedDescription)")
            } else if let record = record {
                print("Saved record to favorites: \(record)")
            }
        }
//        self.state.show.hasFavoritedEpisodes = true //TODO: set this var to true when func is called
}

func updateServerEpisodeIsNotFavorite(filename show: String, code episode: Int) {
    let predicate = NSPredicate(value: true)
    let query = CKQuery(recordType: "episodes", predicate: predicate)
    let operation = CKQueryOperation(query: query)
    operation.desiredKeys = ["filename", "code"]
    
    var records = [String: CKRecord.ID]()
    operation.recordFetchedBlock = { record in
        let filename = record["filename"]!
        let code = String(format: "%@", record["code"]! as! CVarArg)
        let recordID = record.recordID
        records["\(filename)+\(code)"] = recordID
    }
    operation.queryCompletionBlock = { (cursor, error) in
        if let cursor = cursor {
            let newOperation = CKQueryOperation(cursor: cursor)
            newOperation.recordFetchedBlock = operation.recordFetchedBlock
            newOperation.queryCompletionBlock = operation.queryCompletionBlock
            CKContainer(identifier: "iCloud.wilcoxcurtis.ShowDictionary").privateCloudDatabase.add(newOperation)
        } else {
            DispatchQueue.main.async {
                if let error = error { print(error) } else {
                    for (key, value) in records {
                        let filename = String(key.split(separator: "+")[0])
                        let code = Int(key.split(separator: "+")[1])!
                        let id: CKRecord.ID = value
                        if filename == show && code == episode {
                            CKContainer(identifier: "iCloud.wilcoxcurtis.ShowDictionary").privateCloudDatabase.delete(withRecordID: id) { _, _ in print("Deleted \(filename), \(code) from favorites.")}
                        }
                    }
    //                let numFaves = self.state.show.episodes.filter { $0.isFavorite }.count
    //
    //                self.state.show.hasFavoritedEpisodes = (numFaves != 0) // TODO: do these calcs when func is called
                }
            }
        }
    }
    CKContainer(identifier: "iCloud.wilcoxcurtis.ShowDictionary").privateCloudDatabase.add(operation)
}

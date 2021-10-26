/*
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
  var showname: String
  private var records: [Record] = []
  @Published var percentCompleted: Double = 0
  
  init() {
    self.showname = ""
  }
  
  init(_ showname: String) {
    self.showname = showname // really the filename
  }
  
  func getEpisodes(completion: @escaping ([Episode], Bool) -> ()) {
    var episodes: [Episode] = []
    Alamofire.request("https://wilcoxcurtis.com/show-dictionary/files/\(self.showname)_\(Locale.current.languageCode ?? "en").json", method: .get).responseString() { response in
      
      switch response.result {
      case .success(var text):
        self.percentCompleted = 90
        text = text.replacingOccurrences(of: "<pre>", with: "").replacingOccurrences(of: "</pre>", with: "").trimmingCharacters(in: .whitespacesAndNewlines) // remove the pretty-print tags from HTML
        do {
          let decoder = JSONDecoder()
          episodes = try decoder.decode([Episode].self, from: Data(text.utf8)).sorted(by: <)
          saveData(text, filename: self.showname)
          self.queryFavoritism(episodes) { (episodes, hasFaves) in
            self.percentCompleted = 100
            completion(episodes, hasFaves)
          }
        } catch {
          self.mightHaveToLoad(completion: completion)
        }
      case .failure:
        self.mightHaveToLoad(completion: completion)
      }
    }
  }
  
  func mightHaveToLoad(completion: @escaping ([Episode], Bool) -> ()) {
    if let episodes = self.loadData() {
      self.percentCompleted = 100
      completion(episodes, false)
    } else {
      completion([], false)
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
    
  func loadData() -> [Episode]? {
    let lang = Locale.current.identifier
    let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let fileURL = directoryURL.appendingPathComponent(lang).appendingPathComponent(showname).appendingPathExtension("json")
    
    return try? JSONDecoder().decode([Episode].self, from: Data(contentsOf: fileURL)).sorted(by: <)
  }
  
}

struct Record {
  let code: String
  let filename: String
  let id: CKRecord.ID
}
*/

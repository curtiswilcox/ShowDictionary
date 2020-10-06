//
//  GlobalImportantThings.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 12/25/19.
//  Copyright © 2019 wilcoxcurtis. All rights reserved.
//

import CloudKit
import Foundation


func getSeasonText(_ show: Show, _ season: Int) -> String {
  let preColon = "\(NSLocalizedString(show.typeOfSeasons.localizeCapSing, comment: "")) \(season)"
  if let title = show.seasonTitles?[season] {
    return "\(preColon): \(title)"
  }
  else { return preColon }
}

func updateServerEpisodeIsFavorite(filename show: String, code: Int, completion: @escaping ((CKRecord.ID?) -> ())) {
  guard signedIn else {
    completion(nil)
    return
  }
  
  let episodeRecord = CKRecord(recordType: "episodes")
  episodeRecord["filename"] = show
  episodeRecord["code"] = code
  CKContainer(identifier: "iCloud.wilcoxcurtis.ShowDictionary").privateCloudDatabase.save(episodeRecord) { (record, error) in
    if let error = error {
      print("Problem updating favorite episode: \(error.localizedDescription)")
    } else if let record = record {
      print("Saved record to favorites: \(record)")
      completion(record.recordID)
    }
  }
//        self.state.show.hasFavoritedEpisodes = true //TODO: set this var to true when func is called
}

func updateServerEpisodeIsNotFavorite(filename show: String, code episode: Int, id: CKRecord.ID) {
  CKContainer(identifier: "iCloud.wilcoxcurtis.ShowDictionary").privateCloudDatabase.delete(withRecordID: id) { _, _ in print("Deleted \(show), \(episode) from favorites.")}
}

/*
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
*/



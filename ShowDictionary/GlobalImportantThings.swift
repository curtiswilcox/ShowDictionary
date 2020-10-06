//
//  GlobalImportantThings.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 12/25/19.
//  Copyright © 2019 wilcoxcurtis. All rights reserved.
//

import CloudKit
import Foundation


func getSeasonText(_ show: Show, _ season: Int, _ useSections: Bool = true) -> String {
  guard useSections else { return "" }
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
}

func updateServerEpisodeIsNotFavorite(filename show: String, code episode: Int, id: CKRecord.ID) {
  CKContainer(identifier: "iCloud.wilcoxcurtis.ShowDictionary").privateCloudDatabase.delete(withRecordID: id) { _, _ in print("Deleted \(show), \(episode) from favorites.")
  }
}


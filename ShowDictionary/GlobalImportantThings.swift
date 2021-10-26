/*
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

func saveData(_ data: String, filename: String) {
  let lang = Locale.current.identifier
  let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(lang)

  if !FileManager.default.fileExists(atPath: directoryURL.path) {
    do {
      try FileManager.default.createDirectory(atPath: directoryURL.path, withIntermediateDirectories: true, attributes: nil)
    } catch let e {
      print("Couldn't create directory! \(e)")
    }
  }
  let fileURL = directoryURL.appendingPathComponent(filename).appendingPathExtension("json")
  if !FileManager.default.fileExists(atPath: fileURL.path) {
//    print("Doesn't exist!")
    FileManager.default.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
//    print("Exists: \(FileManager.default.fileExists(atPath: fileURL.path))")
  }
  
  do {
    try Data(data.utf8).write(to: fileURL)
  } catch let e {
    print("Couldn't save \(lang)/\(filename).json data! \(e)")
  }
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

*/

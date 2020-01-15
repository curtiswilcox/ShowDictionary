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

        Alamofire.request("https://wilcoxcurtis.com/show-dictionary/files/shows_\(Locale.current.languageCode ?? "en").json", method: .get).responseString() { response in
            switch response.result {
            case .success(var text):
                text = text.replacingOccurrences(of: "<pre>", with: "").replacingOccurrences(of: "</pre>", with: "").trimmingCharacters(in: .whitespacesAndNewlines) // remove the pretty-print tags from HTML
                
                do {
                    let decoder = JSONDecoder()
                    shows = try decoder.decode([Show].self, from: Data(text.utf8)).sorted(by: <)
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

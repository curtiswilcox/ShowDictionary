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
  var data: [ShowData] = []
  private var numberCompleted: CGFloat = 0
  @Published private(set) var percentCompleted: CGFloat = 0
  
  init() {
    getShows() { shows in
      for show in shows {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 30
        URLSession(configuration: config).dataTask(with: show.titleCardURL, completionHandler: { (data, response, error) in
          DispatchQueue.main.async {
            if let imageData = data, let img = UIImage(data: imageData) {
              self.data.append(ShowData(show, img))
              self.saveImageData(imageData, show: show.filename)
            } else {
              if let img = self.savedImage(show: show.filename) {
                self.data.append(ShowData(show, img))
              } else {
                self.data.append(ShowData(show)) // img is nil
              }
            }
            self.numberCompleted += 1
            self.percentCompleted = self.numberCompleted / CGFloat(shows.count) * 100
            self.data.sort(by: <)
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
        } catch {
          completion([])
        }
      case .failure:
        completion([])
      }
    }
  }
  
  func saveImageData(_ data: Data, show: String) {
    let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let fileURL = URL(fileURLWithPath: "\(show)-title-card", relativeTo: directoryURL).appendingPathExtension("txt")
    
    if FileManager.default.fileExists(atPath: fileURL.path) {
      do {
        if try Data(contentsOf: fileURL) == data { /*print("\(show) file already exists!");*/ return }
      } catch { /* doesn't matter */ }
    }
    
    do {
      try data.write(to: fileURL)
      print("\(show) file written!")
    } catch {
      // leave empty for now
    }
  }
  
  func savedImage(show: String) -> UIImage? {
    let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let fileURL = URL(fileURLWithPath: "\(show)-title-card", relativeTo: directoryURL).appendingPathExtension("txt")
    
    guard FileManager.default.fileExists(atPath: fileURL.path) else { /*print("\(show) file doesn't exist.");*/ return nil }
    
    do {
      let data = try Data(contentsOf: fileURL)
      if let image = UIImage(data: data) {
//        print("\(show) file exists and loaded!")
        return image
      }
//      print("\(show) file exists and NOT loaded!")
      return nil
    } catch {
//      print("\(show) file had a problem loading!")
      return nil
    }
  }
}

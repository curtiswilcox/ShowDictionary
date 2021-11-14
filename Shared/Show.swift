//
//  Show.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 10/25/21.
//  Copyright © 2021 wilcoxcurtis. All rights reserved.
//

import Foundation

struct Show: Observable {
    let name: String
    let numberOfSeasons: Int
    let numberOfEpisodes: Int
    let summary: String
    let seasonType: SeasonType
    let titleCardURL: URL
    let filename: String
    let sortName: String
    let seasonTitles: [Int: String]?
    let characters: [Portrayal]?
    var hasFavoriteEpisodes = false
    
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try values.decode(String.self, forKey: .name)
        self.numberOfSeasons = Int(try values.decode(String.self, forKey: .numberOfSeasons))!
        self.numberOfEpisodes = Int(try values.decode(String.self, forKey: .numberOfEpisodes))!
        self.summary = try values.decode(String.self, forKey: .summary)
        self.seasonType = try values.decode(SeasonType.self, forKey: .seasonType)
        self.titleCardURL = URL(string: try values.decode(String.self, forKey: .titleCardURL))!
        self.filename = try values.decode(String.self, forKey: .filename)
        self.sortName = try values.decode(String.self, forKey: .sortName)
        
        if let seasonTitles = try? values.decode(String.self, forKey: .seasonTitles), let data = seasonTitles.data(using: .utf8), let titles = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String] {
            
            var intTitles = [Int: String]()
            for (key, value) in titles {
                intTitles[Int(key)!] = value
            }
            self.seasonTitles = intTitles
        } else {
            self.seasonTitles = nil
        }
                        
        if let characters = try? values.decode(String.self, forKey: .characters), let data = characters.data(using: .utf8), let initialCharacters = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: [String: Any]] {
            do {
            self.characters = try initialCharacters.reduce(into: [Portrayal]()) { result, entry in
                let character = try Person(fullName: entry.key.trimmingCharacters(in: .whitespacesAndNewlines))
                let actor = try Person(fullName: (entry.value["actor"] as! String).trimmingCharacters(in: .whitespacesAndNewlines))
                let appearances = (entry.value["appearances"] as! NSArray).compactMap {
                    ($0 as AnyObject).integerValue
                }
                result.append(Portrayal(character: character, actor: actor, appearances: appearances))
            }
            } catch let e {
                print(name, e)
                self.characters = nil
            }
        } else {
            self.characters = nil
        }
    }
    
    func matchesSearchText(_ searchText: String) -> Bool {
        guard !searchText.isEmpty else { return true }
        return name.localizedLowercase.contains(searchText.localizedLowercase)
    }
    
    func getSavedImage() throws -> Data {
        return try Data(contentsOf: getURL())
    }
    
    func saveImage() async {
        guard let (data, _) = try? await URLSession.shared.data(from: titleCardURL) else { return }
        
        do {
            // no point in saving old photo repeatedly
            guard try getSavedImage() != data else { return }
        } catch {
            if !FileManager.default.fileExists(atPath: getURL().path) {
                do {
                    try createURLFile()
                } catch let e {
                    print(e)
                }
            }
            FileManager.default.createFile(atPath: getURL().path, contents: nil, attributes: nil)
        }
        do {
            try data.write(to: getURL())
        } catch let e {
            print("Writing error: \(e)")
        }
    }
    
    private func createURLFile() throws {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let localeDirectory = documentDirectory
            .appendingPathComponent("title-cards", isDirectory: true)
            .appendingPathComponent(Locale.current.identifier, isDirectory: true)
        if !FileManager.default.fileExists(atPath: localeDirectory.path) {
            try FileManager.default.createDirectory(at: localeDirectory, withIntermediateDirectories: true)
        }
    }
    
    private func getURL() -> URL {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("title-cards", isDirectory: true)
            .appendingPathComponent(Locale.current.identifier, isDirectory: true)
            .appendingPathComponent(filename, isDirectory: false)
    }
}

extension Show {
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case numberOfSeasons = "NumberOfSeasons"
        case numberOfEpisodes = "NumberOfEpisodes"
        case summary = "Description"
        case seasonType = "TypeOfSeasons"
        case titleCardURL = "URL"
        case filename = "Filename"
        case sortName = "SortName"
        case seasonTitles = "SeasonTitles"
        case characters = "Characters"
    }
}

extension Show: Comparable {
    static func <(lhs: Show, rhs: Show) -> Bool {
        let lhsName = lhs.sortName.alphanumeric().localizedLowercase
        let rhsName = rhs.sortName.alphanumeric().localizedLowercase
        return lhsName.compare(rhsName, options: .diacriticInsensitive) == .orderedAscending
//        lhs.sortName.alphanumeric().localizedLowercase < rhs.sortName.alphanumeric().localizedLowercase
    }
    
    static func ==(lhs: Show, rhs: Show) -> Bool {
        lhs.filename == rhs.filename
    }
}

extension Show: CustomStringConvertible {
    var description: String {
        """
        Name: \(name)
        Number of Seasons: \(numberOfSeasons)
        Number of Episodes: \(numberOfEpisodes)
        Summary: \(summary)
        Season Type: \(seasonType)
        Title Card URL: \(titleCardURL)
        Filename: \(filename)
        Sort Name: \(sortName)
        Season Titles: \(seasonTitles != nil ? String(describing: seasonTitles!) : "no season titles")
        Characters: \(characters != nil ? String(describing: characters!) : "no listed characters")
        """
    }
}

extension Show: Identifiable {
    var id: String {
        filename
    }
}

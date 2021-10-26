//
//  Show.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 10/25/21.
//  Copyright © 2021 wilcoxcurtis. All rights reserved.
//

import Foundation

enum SeasonType: String, Decodable {
    case book, season, series
}

protocol Observable: Comparable, CustomStringConvertible, Decodable, Identifiable { }

class Show: Observable {
    let name: String
    let numberOfSeasons: Int
    let numberOfEpisodes: Int
    let summary: String
    let seasonType: SeasonType
    let titleCardURL: URL
    let filename: String
    let sortName: String
    let seasonTitles: [Int: String]?
    let characters: [String: (`actor`: String, appearances: [Int])]?
    
    required init(from decoder: Decoder) throws {
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
            self.characters = initialCharacters.reduce(into: [:]) { result, entry in
                let character = entry.key.trimmingCharacters(in: .whitespacesAndNewlines)
                let actor = (entry.value["actor"] as! String).trimmingCharacters(in: .whitespacesAndNewlines)
                let appearances = (entry.value["appearances"] as! NSArray).compactMap {
                    ($0 as AnyObject).integerValue
                }
                result?[character] = (actor: actor, appearances: appearances)
            }
        } else {
            self.characters = nil
        }
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
        lhs.sortName.alphanumeric().lowercased() < rhs.sortName.alphanumeric().lowercased()
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

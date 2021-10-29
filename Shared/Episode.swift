//
//  Episode.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 10/25/21.
//  Copyright © 2021 wilcoxcurtis. All rights reserved.
//

import Foundation

struct Episode: Observable {
    let code: Int
    let name: String
    let summary: String
    
    let seasonNumber: Int
    let episodeInSeason: Int
    let episodeInShow: Int
    
    let writers: [Person]?
    let directors: [Person]?
    
    let airdate: Date
    let keywords: [String]?
    
    let runtime: Int?
    
    var isFavorite = false
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.code = Int(try values.decode(String.self, forKey: .code))!
        self.name = try values.decode(String.self, forKey: .name)
        self.summary = try values.decode(String.self, forKey: .summary)
        self.seasonNumber = Int(try values.decode(String.self, forKey: .seasonNumber))!
        self.episodeInSeason = Int(try values.decode(String.self, forKey: .episodeInSeason))!
        self.episodeInShow = Int(try values.decode(String.self, forKey: .episodeInShow))!
        self.writers = try? values.decode(String.self, forKey: .writers).components(separatedBy: " and ").map {
            do {
                return try Person(fullName: $0)
            } catch let e{
                print("writer error: \($0)")
                throw e
            }
            
        }
        self.directors = try? values.decode(String.self, forKey: .directors).components(separatedBy: " and ").compactMap {
            do { return try Person(fullName: $0) } catch let e{ print("director error: \($0)"); throw e}}
        self.airdate = Date(hyphenated: try values.decode(String.self, forKey: .airdate))
        self.keywords = {
            guard let keywords = try? values.decode(String.self, forKey: .keywords), keywords.lowercased() != "none", !keywords.isEmpty else { return nil }
            return keywords.components(separatedBy: ", ")
        }()
        self.runtime = try? Int(values.decode(String.self, forKey: .runtime))
    }
    
    func matchesSearchText(_ searchText: String) -> Bool {
        guard !searchText.isEmpty else { return true }
        let searchText = searchText.lowercased()
        
        let nameContains = name.lowercased().contains(searchText)
        let summaryContains = summary.lowercased().contains(searchText)
        let keywordsContains = keywords?
            .map({ $0.lowercased().contains(searchText) })
            .reduce(false, { $0 || $1 })
        ?? false
        
        return nameContains || summaryContains || keywordsContains
    }
    
    func runtimeDescription() -> String? {
        guard var minutes = self.runtime else { return nil }
        var desc = ""
        if minutes >= 60 {
            let hours = minutes / 60
            minutes %= 60
            
            desc += "\(hours) hour\(hours != 1 ? "s" : "")"
        }
        if minutes > 0 {
            if !desc.isEmpty {
                desc += ", "
            }
            desc += "\(minutes) minute\(minutes != 1 ? "s" : "")"
        }
        return desc
    }
}

extension Episode {
    enum CodingKeys: String, CodingKey {
        case code = "Code"
        case name = "Name"
        case summary = "Summary"
        case seasonNumber = "SeasonNumber"
        case episodeInSeason = "EpisodeInSeason"
        case episodeInShow = "EpisodeInSeries"
        case writers = "Writer"
        case directors = "Director"
        case airdate = "Airdate"
        case keywords = "Keywords"
        case runtime = "Runtime"
    }
}

extension Episode: Comparable {
    static func <(lhs: Episode, rhs: Episode) -> Bool {
        lhs.code < rhs.code
    }
    
    static func ==(lhs: Episode, rhs: Episode) -> Bool {
        lhs.code == rhs.code
    }
}

extension Episode: CustomStringConvertible {
    var description: String {
        """
        Code: \(code)
        Name: \(name)
        Summary: \(summary)
        SeasonNumber: \(seasonNumber)
        Episode in Season: \(episodeInSeason)
        Episode in Show: \(episodeInShow)
        Writer: \(String(describing: writers))
        Director: \(String(describing: directors))
        Airdate: \(airdate.written())
        Keywords: \(keywords != nil ? String(describing: keywords!) : "no keywords")
        Runtime: \(String(describing: runtime))
        """
    }
}

extension Episode: Identifiable {
    var id: String {
        "\(code)\(name)"
    }
}

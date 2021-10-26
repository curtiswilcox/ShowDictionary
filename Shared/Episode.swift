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
    
    let writer: String
    let director: String
    
    let airdate: Date
    let keywords: [String]?
    
    let runtime: Int
    
    var isFavorite = false
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.code = Int(try values.decode(String.self, forKey: .code))!
        self.name = try values.decode(String.self, forKey: .name)
        self.summary = try values.decode(String.self, forKey: .summary)
        self.seasonNumber = Int(try values.decode(String.self, forKey: .seasonNumber))!
        self.episodeInSeason = Int(try values.decode(String.self, forKey: .episodeInSeason))!
        self.episodeInShow = Int(try values.decode(String.self, forKey: .episodeInShow))!
        self.writer = try values.decode(String.self, forKey: .writer)
        self.director = try values.decode(String.self, forKey: .director)
        self.airdate = Date(hyphenated: try values.decode(String.self, forKey: .airdate))
        self.keywords = {
            guard let keywords = try? values.decode(String.self, forKey: .keywords), keywords.lowercased() != "none", !keywords.isEmpty else { return nil }
            return keywords.components(separatedBy: ", ")
        }()
        self.runtime = Int(try values.decode(String.self, forKey: .runtime))!
    }
    
    func validItem(searchText: String) -> Bool {
        let searchText = searchText.lowercased()
        
        let nameContains = name.lowercased().contains(searchText)
        let summaryContains = summary.lowercased().contains(searchText)
        let keywordsContains = keywords?
            .map({ $0.lowercased().contains(searchText) })
            .reduce(false, { $0 || $1 })
        ?? false
        
        return nameContains || summaryContains || keywordsContains
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
        case writer = "Writer"
        case director = "Director"
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
        Writer: \(writer)
        Director: \(director)
        Airdate: \(airdate.written())
        Keywords: \(keywords != nil ? String(describing: keywords!) : "no keywords")
        Runtime: \(runtime)
        """
    }
}

extension Episode: Identifiable {
    var id: String {
        "\(code)\(name)"
    }
}

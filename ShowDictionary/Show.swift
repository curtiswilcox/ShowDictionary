//
//  Show.swift
//  ShowDictionaryMac
//
//  Created by Curtis Wilcox on 5/26/19.
//  Copyright © 2019 wilcoxcurtis. All rights reserved.
//

import Foundation

final class Show : Identifiable { // the Swift fields
	let name: String
	let filename: String
	let description: String
	let numberOfSeasons: Int
	let numberOfEpisodes: Int
	let typeOfSeasons: SeasonType
	let discSearch: Bool
	let titleCardURL: URL
	let seasonTitles: [Int: String]?
	let characters: [Character]?

	@Published var hasFavoritedEpisodes: Bool = false
	@Published var episodes: [Episode]!

	init(name: String) {
		self.name = name
		self.filename = name.lowercased().filter { String($0).isAlphanumeric }
		self.description = ""
		self.numberOfSeasons = 0
		self.numberOfEpisodes = 0
		self.typeOfSeasons = .season
		self.discSearch = false
		self.titleCardURL = URL(string: "https://www.google.com")!
		self.seasonTitles = nil
		self.characters = nil
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		name = try values.decode(String.self, forKey: .name)
		filename = try values.decode(String.self, forKey: .filename)
		description = try values.decode(String.self, forKey: .description)
		numberOfSeasons = try Int(values.decode(String.self, forKey: .numberOfSeasons))!
		numberOfEpisodes = try Int(values.decode(String.self, forKey: .numberOfEpisodes))!
		typeOfSeasons = try SeasonType(rawValue: values.decode(String.self, forKey: .typeOfSeasons))!
		discSearch = (try values.decode(String.self, forKey: .discSearch)) == "1" ? true : false
		titleCardURL = try values.decode(URL.self, forKey: .titleCardURL)
		if let seasonTitles = try values.decode(String?.self, forKey: .seasonTitles) {
			let stringTitles = try JSONSerialization.jsonObject(with: seasonTitles.data(using: .utf8)!, options: []) as? [String: String]
			var intTitles = [Int: String]()
			for (key, value) in stringTitles! {
				intTitles[Int(key)!] = value
			}
			self.seasonTitles = intTitles
		} else {
			self.seasonTitles = nil
		}

		if let characters = try values.decode(String?.self, forKey: .characters) {
			let initialCharacters = try JSONSerialization.jsonObject(with: characters.data(using: .utf8)!, options: []) as? [[String: String]]
            self.characters = initialCharacters?.reduce(into: []) { result, entry in
                let key = Array(entry.keys)[0]
                let value = entry[Array(entry.keys)[0]]!
                let character = Person(name: key.trimmingCharacters(in: .whitespacesAndNewlines))
                let actor = Person(name: value.trimmingCharacters(in: .whitespacesAndNewlines))
                result?.append(Character(actor: actor, character: character))
            }
		} else {
			self.characters = nil
		}
	}

	func getAvailableSearchMethods() -> [SearchMethod] {
        var methodArray: [SearchMethod] = [.description, /*.name, */.showAll, .season, .keyword]
//				[.description, .name, .keyword, .writer, .episodeNumber, .singleAirdate, .rangeAirdates, .season]
        
        if self.hasFavoritedEpisodes {
            methodArray.append(.favorite)
        }

		for episode in episodes ?? [] where episode.directors != nil {
			methodArray.append(.director)
			break
		}

		for episode in episodes ?? [] where episode.writers != nil {
			methodArray.append(.writer)
			break
		}

        if self.filename.lowercased().contains("doctorwho") {
			methodArray.append(contentsOf: [.doctor, .companion])
		}

		if let _ = self.characters {
			methodArray.append(.character)
		}
        
        methodArray.append(contentsOf: [.random, .episodeNumber, .singleAirdate, .rangeAirdates])

		if self.discSearch {
			methodArray.append(.disc)
		}

		return methodArray
	}

	private func getImageData(completion: @escaping (Data?) -> ()) {
		URLSession(configuration: .default).dataTask(with: self.titleCardURL) { (data, response, error) in
			if let data = data {
				completion(data)
			} else {
				completion(nil)
			}
		}.resume()
	}
}

extension Show {
	enum CodingKeys: String, CodingKey { // the JSON keys
		case name = "Name"
		case filename = "Filename"
		case description = "Description"
		case numberOfSeasons = "NumberOfSeasons"
		case numberOfEpisodes = "NumberOfEpisodes"
		case typeOfSeasons = "TypeOfSeasons"
		case discSearch = "DiscSearch"
		case titleCardURL = "URL"
		case seasonTitles = "SeasonTitles"
		case characters = "Characters"
	}
}

extension Show: Codable {}

extension Show: Comparable {
	static func == (lhs: Show, rhs: Show) -> Bool {
		return lhs.name.lowercased() == rhs.name.lowercased()
	}

	static func < (lhs: Show, rhs: Show) -> Bool {
		let first = lhs.name.lowercased().filter { String($0).isAlphanumeric || String($0) == " " }
		let second = rhs.name.lowercased().filter { String($0).isAlphanumeric || String($0) == " " }

		var mutFirst = first
		var mutSecond = second

		let articles = ["the", "el", "los", "la", "las"] // TODO: this is bad
		for article in articles where mutFirst.hasPrefix("\(article) ") {
//			if mutFirst.hasPrefix("\(article) ") {
				mutFirst = String(first.dropFirst(article.count + 1))
				break
//			}
		}
		for article in articles where mutSecond.hasPrefix("\(article) ") {
//			if mutSecond.hasPrefix("\(article) ") {
				mutSecond = String(second.dropFirst(article.count + 1))
				break
//			}
		}
		return mutFirst.lowercased() < mutSecond.lowercased()
	}
}

extension Show: ObservableObject {}

extension Show {
    struct Character: Codable, Equatable, Hashable, Identifiable {
        var id: String { return character.lastName }
        let actor: Person
        let character: Person
        
        static func == (lhs: Character, rhs: Character) -> Bool {
            return lhs.actor == rhs.actor && lhs.character == rhs.character
        }
    }
}

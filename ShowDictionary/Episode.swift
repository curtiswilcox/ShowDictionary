//
//  Episode.swift
//  ShowDictionaryWatchOS Extension
//
//  Created by Curtis Wilcox on 6/16/19.
//  Copyright © 2019 Curtis Wilcox. All rights reserved.
//

import CloudKit.CKRecord
import SwiftUI

final class Episode {
	let code: Int
	let airdate: Date
	let title: String
	let writers: [Person]?
	let directors: [Person]?
	let summary: String
	let keywords: String?
	let runtime: Int?
	
	private(set) var doctors: [String]? // (Classic) Doctor Who
	private let secondaryDoctors: String? = nil // for loading the above information
	private(set) var companions: [Person]? // (Classic) Doctor Who
	private let secondaryCompanions: String? = nil // for loading the above information
	
    let characters: [Show.Character]?
	
	let seasonNumber: Int
	let numberInSeason: Int
	let numberInSeries: Int
	
	private(set) var discInfo: (season: String, disc: String, episode: String)?
	private let discNumber: Int? = nil // for loading the above information
	private let episodeOnDisc: Int? = nil // for loading the above information
	
    @Published var isFavorite: Bool = false
    
    var favoritedID: CKRecord.ID? = nil
	
    init() {
        self.code = 0
        self.airdate = Date()
        self.title = ""
        self.writers = nil
        self.directors = nil
        self.summary = ""
        self.keywords = nil
        self.runtime = nil
        self.doctors = nil
        self.companions = nil
        self.characters = nil
        self.seasonNumber = 0
        self.numberInSeason = 0
        self.numberInSeries = 0
    }
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)

		code = try Int(values.decode(String.self, forKey: .code))!
		airdate = try Date(hyphenated: values.decode(String.self, forKey: .airdate))
		title = try values.decode(String.self, forKey: .title).trimmingCharacters(in: .whitespacesAndNewlines)

        do {
            let writer = try values.decode(String?.self, forKey: .writers)?.trimmingCharacters(in: .whitespacesAndNewlines)
            var writers = [Person]()
            
            if let writer = writer {
                for w in writer.components(separatedBy: NSLocalizedString(" and ", comment: "")) {
                    writers.append(Person(name: w))
                }
                self.writers = writers
            } else {
                self.writers = nil
            }
        } catch { writers = nil }

        do {
            let director = try values.decode(String?.self, forKey: .directors)?.trimmingCharacters(in: .whitespacesAndNewlines)
            var directors = [Person]()
            
            if let director = director {
                for d in director.components(separatedBy: NSLocalizedString(" and ", comment: "")) {
                    directors.append(Person(name: d))
                }
                self.directors = directors
            } else {
                self.directors = nil
            }
        } catch { directors = nil }

		summary = try values.decode(String.self, forKey: .summary).trimmingCharacters(in: .whitespacesAndNewlines)

        do { keywords = try values.decode(String?.self, forKey: .keywords)?.trimmingCharacters(in: .whitespacesAndNewlines) }
		catch { keywords = nil }

		do { runtime = try Int(values.decode(String?.self, forKey: .runtime) ?? "") }
		catch { runtime = nil }
        
		do {
			if var doctors = (try values.decode(String?.self, forKey: .doctors))?.replacingOccurrences(of: "\\", with: ""),//.trimmingCharacters(in: .whitespacesAndNewlines),
                var companions = (try values.decode(String?.self, forKey: .companions))?.replacingOccurrences(of: "\\", with: "") {//}.trimmingCharacters(in: .whitespacesAndNewlines) {

				doctors.append(contentsOf: ",\((try values.decode(String.self, forKey: .secondaryDoctors)).replacingOccurrences(of: "\\", with: "").replacingOccurrences(of: ", ", with: ","))")
				self.doctors = doctors.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }

				companions.append(contentsOf: ",\((try values.decode(String.self, forKey: .secondaryCompanions)).replacingOccurrences(of: "\\", with: "").replacingOccurrences(of: ", ", with: ","))")
                self.companions = companions.split(separator: ",").map { Person(name: String($0).trimmingCharacters(in: .whitespacesAndNewlines)) }
			} else { self.doctors = nil; self.companions = nil; }
		} catch { self.doctors = nil; self.companions = nil }
        
		do {
			if let characters = try values.decode(String?.self, forKey: .characters) {
                let initialCharacters = try JSONSerialization.jsonObject(with: characters.data(using: .utf8)!, options: []) as? [String: String]

                self.characters = initialCharacters?.reduce(into: []) { result, entry in
                    let character = Person(name: entry.key.trimmingCharacters(in: .whitespacesAndNewlines))
                    let actor = Person(name: entry.value.trimmingCharacters(in: .whitespacesAndNewlines))
                    result?.append(Show.Character(actor: actor, character: character))
                }
			} else {
				self.characters = nil
			}
		} catch { self.characters = nil }

		seasonNumber = try Int(values.decode(String.self, forKey: .seasonNumber))!
		numberInSeason = try Int(values.decode(String.self, forKey: .numberInSeason))!
		numberInSeries = try Int(values.decode(String.self, forKey: .numberInSeries))!
		
		do {
			if let discNumber = try values.decode(String?.self, forKey: .discNumber)?.trimmingCharacters(in: .whitespacesAndNewlines),
				let episodeOnDisc = try values.decode(String?.self, forKey: .episodeOnDisc)?.trimmingCharacters(in: .whitespacesAndNewlines) {
				discInfo = (String(seasonNumber), discNumber, episodeOnDisc)				
			}
		} catch { discInfo = nil }
	}
    

	func runtimeDescription(/*lang: AvailableLanguage*/) -> String? {
		guard let minutes = self.runtime else {
			return nil
		}

		var desc = ""
		if minutes >= 60 {
			let hours = minutes / 60
			let leftoverMinutes = minutes % 60

			desc += "\(hours)"
			if hours > 1 {
//				desc += " \("hours".localize(lang: lang)), "
                desc += " \(NSLocalizedString("hours", comment: "")), "
			} else {
//				desc += " \("hour".localize(lang: lang)), "
                desc += " \(NSLocalizedString("hour", comment: "")), "
			}

			if leftoverMinutes > 0 {
				desc += "\(leftoverMinutes) "
				if leftoverMinutes > 1 {
//					desc += " \("minutes".localize(lang: lang))"
                    desc += " \(NSLocalizedString("minutes", comment: ""))"
				} else {
//					desc += " \("minute".localize(lang: lang))"
                    desc += " \(NSLocalizedString("minute", comment: ""))"
				}
            } else {
                desc = String(desc.dropLast(2))
            }
		} else {
			desc += "\(minutes)"
			if minutes > 1 {
//				desc += " \("minutes".localize(lang: lang))"
                desc += " \(NSLocalizedString("minutes", comment: ""))"
			} else if minutes == 1 {
//				desc += " \("minute".localize(lang: lang))"
                desc += " \(NSLocalizedString("minute", comment: ""))"
			}
		}
		return desc
	}

}

extension Episode {
	enum CodingKeys: String, CodingKey {
		case code = "Code"
		case airdate = "Airdate"
		case title = "Name"
		case writers = "Writer"
		case directors = "Director"
		case summary = "Summary"
		case keywords = "Keywords"
		case runtime = "Runtime"
		case doctors = "Doctor"
		case secondaryDoctors = "SecondaryDoctors"
		case companions = "Companion"
		case secondaryCompanions = "SecondaryCompanions"
		case characters = "Characters"
		case discNumber = "DiscNumber"
		case numberInSeason = "EpisodeInSeason"
		case numberInSeries = "EpisodeInSeries"
		case episodeOnDisc = "EpisodeOnDisc"
		case seasonNumber = "SeasonNumber"
	}
}

extension Episode: Codable {}

extension Episode: Comparable {
	static func == (lhs: Episode, rhs: Episode) -> Bool {
		return lhs.code == rhs.code
	}

	static func < (lhs: Episode, rhs: Episode) -> Bool {
		return lhs.code < rhs.code
	}
}

extension Episode: CustomStringConvertible {
	var description: String {
		get {
			"\(self.title): \(self.code)"
		}
	}
}

extension Episode: Hashable {
	func hash(into hasher: inout Hasher) {
		hasher.combine(self.code)
	}
}

extension Episode: Identifiable {
    var id: Int { self.code }
}

extension Episode: ObservableObject {}

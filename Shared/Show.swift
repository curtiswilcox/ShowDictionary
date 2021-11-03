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
//    let doctors: [Person]?
//    let companions: [Person]?
    
    
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
        
        /*
        if let doctor = try? values.decode(String.self, forKey: .doctor) {
            if let secondaryDoctors = try? values.decode(String.self, forKey: .secondaryDoctors).components(separatedBy: ", ") {
                var doctors = [doctor]
                doctors.append(contentsOf: secondaryDoctors)
                self.doctors = doctors.map { doctor in
                    if doctor.lowercased() != "war" {
                        let formatter = NumberFormatter()
                        formatter.numberStyle = .spellOut
                        let doctorNum = formatter.number(from: doctor)!
                        formatter.numberStyle = .ordinal
                        let ordinal = formatter.string(from: doctorNum)!.capitalized
                        
                        return Person(firstName: "The \(ordinal)", middleName: nil, lastName: "Doctor")
                    } else {
                        return Person(firstName: "The War", middleName: nil, lastName: "Doctor")
                    }
                }
            } else {
                let formatter = NumberFormatter()
                formatter.numberStyle = .spellOut
                let doctorNum = formatter.number(from: doctor)!
                formatter.numberStyle = .ordinal
                let ordinal = formatter.string(from: doctorNum)!.capitalized
                
                self.doctors = [Person(firstName: "The \(ordinal)", middleName: nil, lastName: "Doctor")]
            }
        } else {
            self.doctors = nil
        }
        
        if let companion = try? values.decode(String.self, forKey: .companion) {
            if let secondaryCompanions = try? values.decode(String.self, forKey: .secondaryCompanions).components(separatedBy: ", ") {
                var companions = [companion]
                companions.append(contentsOf: secondaryCompanions)
                self.companions = companions.compactMap { companion in
                    try? Person(fullName: companion)
                }
            } else {
                self.companions = try? [Person(fullName: companion)]
            }
        } else {
            self.companions = nil
        }
         */
    }
    
    func matchesSearchText(_ searchText: String) -> Bool {
        guard !searchText.isEmpty else { return true }
        return name.lowercased().contains(searchText.lowercased())
    }
    
    func getImage() throws -> Data {
        let lang = Locale.current.identifier
        let filename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(filename)_\(lang)-title-card.txt")
        
        return try Data(contentsOf: filename)
    }
    
    func saveImage() async {
        guard let (data, _) = try? await URLSession.shared.data(from: titleCardURL) else { return }
        guard let savedData = try? getImage(), savedData != data else { return } // no point in saving old photo repeatedly
        let lang = Locale.current.identifier
        let filename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(filename)_\(lang)-title-card.txt")
        
        try? data.write(to: filename)
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
//        case doctor = "Doctor"
//        case companion = "Companion"
//        case secondaryDoctors = "SecondaryDoctors"
//        case secondaryCompanions = "SecondaryCompanions"
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

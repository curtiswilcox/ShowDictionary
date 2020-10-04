//
//  SearchMethod.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 8/5/18.
//  Copyright © 2018 Curtis Wilcox. All rights reserved.
//

import Foundation

enum SearchMethod: String, Identifiable {
  var id: String { rawValue }
  
  case character, companion, description, director, disc, doctor, episodeNumber, favorite, keyword, /*name,*/ random, rangeAirdates, season, showAll, singleAirdate, writer
  
  func toString(seasonType: SeasonType) -> String {
    switch (self) {
    case .character:
      return "character".localizeWithFormat(quantity: 1).capitalized
    case .companion:
      return "companion".localizeWithFormat(quantity: 1).capitalized
    case .description:
      return NSLocalizedString("description", comment: "").capitalized
    case .director:
      return "director".localizeWithFormat(quantity: 1).capitalized
    case .disc:
      return NSLocalizedString("Disc Location", comment: "")
    case .doctor:
      return NSLocalizedString("Doctor", comment: "")
    case .episodeNumber:
      return NSLocalizedString("Episode Number", comment: "")
    case .favorite:
      return NSLocalizedString("favorites", comment: "display all favorited episodes").capitalized
    case .keyword:
      return NSLocalizedString("Keyword", comment: "")
    /*case .name:
     return NSLocalizedString("Name", comment: "")*/
    case .random:
      return NSLocalizedString("random", comment: "").capitalized
    case .rangeAirdates:
      return NSLocalizedString("Range of Airdates", comment: "")
    case .season:
      return seasonType.localizeCapSing
    case .showAll:
      return NSLocalizedString("all", comment: "display all (episodes)").capitalized
    case .singleAirdate:
      return NSLocalizedString("Single Airdate", comment: "")
    case .writer:
      return "writer".localizeWithFormat(quantity: 1).capitalized
    }
  }
  
  func desc(seasonType: SeasonType) -> String {
    switch (self) {
    case .character:
      return String(format: NSLocalizedString("Episodes with a specific %@", comment: ""), "character".localizeWithFormat(quantity: 1))
    case .companion:
      return String(format: NSLocalizedString("Episodes with a specific %@", comment: ""), "companion".localizeWithFormat(quantity: 1))
    case .description:
      return NSLocalizedString("A synopsis of the show", comment: "")
    case .director:
      let searchPortion = NSLocalizedString("Search episodes by %@", comment: "")
      let their = "their".localizeWithFormat(quantity: 1)
      let director = "director".localizeWithFormat(quantity: 1)
      return String(format: searchPortion, "\(their) \(director)")
    case .disc:
      return NSLocalizedString("DVD disc location", comment: "")
    case .doctor:
      return String(format: NSLocalizedString("Episodes with a specific %@", comment: ""), "doctor".localizeWithFormat(quantity: 1))
    case .episodeNumber:
      return NSLocalizedString("Enter the number of an episode", comment: "")
    case .favorite:
      return NSLocalizedString("show favorited episodes", comment: "").capitalizeFirstLetter()
    case .keyword:
      return NSLocalizedString("Search episodes by a word or phrase", comment: "")
    /*case .name:
      return "Show all episodes whose name contains entered text".localize(lang: lang)
      return NSLocalizedString("Show all episodes whose name contains entered text", comment: "")
     */
    case .random:
      return NSLocalizedString("Display a random episode", comment: "")
    case .rangeAirdates:
      return NSLocalizedString("Show episodes between two dates", comment: "")
    case .season:
      return NSLocalizedString("show \(seasonType.lowPlur)", comment: "display all \(seasonType.lowPlur)").capitalizeFirstLetter()
    case .showAll:
      return NSLocalizedString("show all episodes", comment: "display all episodes").capitalizeFirstLetter()
    case .singleAirdate:
      return NSLocalizedString("Show episode that aired at or within one week of chosen date", comment: "")
    case .writer:
      let searchPortion = NSLocalizedString("Search episodes by %@", comment: "")
      let their = "their".localizeWithFormat(quantity: 1)
      let writer = "writer".localizeWithFormat(quantity: 1)
      return String(format: searchPortion, "\(their) \(writer)")
    }
  }
/*
	func localize(seasonType: SeasonType/*, lang: AvailableLanguage*/) -> String {
		switch (self) {
		case .character:
			return NSLocalizedString(self.toString(seasonType: seasonType), comment: "Character in episode")
		case .companion:
			return NSLocalizedString(self.toString(seasonType: seasonType), comment: "Doctor Who companion")
		case .description:
			return NSLocalizedString(self.toString(seasonType: seasonType), comment: "Description of the show")
		case .director:
			return NSLocalizedString(self.toString(seasonType: seasonType), comment: "Episode's director(s)")
		case .disc:
			return NSLocalizedString(self.toString(seasonType: seasonType), comment: "Location of episode on disc")
		case .doctor:
			return NSLocalizedString(self.toString(seasonType: seasonType), comment: "Doctor Who regeneration")
		case .episodeNumber:
			return NSLocalizedString(self.toString(seasonType: seasonType), comment: "Number of the episode in show")
		case .favorite:
			return NSLocalizedString(self.toString(seasonType: seasonType), comment: "Episodes that the user has favorited")
		case .keyword:
			return NSLocalizedString(self.toString(seasonType: seasonType), comment: "Word in the episode's summary, or its name")
		/*case .name:
			return NSLocalizedString(self.toString(seasonType: seasonType), comment: "The episode's name")*/
		case .random:
			return NSLocalizedString(self.toString(seasonType: seasonType), comment: "A randomly generated episode")
		case .rangeAirdates:
			return NSLocalizedString(self.toString(seasonType: seasonType), comment: "Episodes between two dates")
		case .season:
//			return seasonType.localizeCapSing(lang)
            return seasonType.localizeCapSing
//			return seasonType.rawValue
		case .showAll:
			return NSLocalizedString(self.toString(seasonType: seasonType), comment: "Show all episodes from the show")
		case .singleAirdate:
            return NSLocalizedString(self.toString(seasonType: seasonType), comment: "Episodes within one week of a date")
		case .writer:
			return NSLocalizedString(self.toString(seasonType: seasonType), comment: "Episode's author(s)")
		}
	}*/
}

//
//  EpisodeDetailView.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 12/22/19.
//  Copyright © 2019 wilcoxcurtis. All rights reserved.
//

import SwiftUI

struct EpisodeDetailView: View {
    let show: Show
    let episode: Episode
    
    @State private var attributes = [Attribute]()
    
    var body: some View {
        HStack {
            ScrollView {
                Divider()
                GridStack(rows: self.attributes.count, columns: 2) { (row, col) in
                    if col == 0 {
                        Text(self.attributes[row].key)
                            .padding(.leading, 20)
                        Spacer()
                    } else {
                        Text(self.attributes[row].value)
                            .padding(.trailing, 20)
                        .lineSpacing(1)
                    }
                }
                .padding()
                .onAppear {
                    self.attributes = self.determineAttributes()
                }
            }
        }
        .navigationBarTitle(episode.title)
    }
        
    private struct Attribute: Identifiable {
        let key: String
        let value: String
        
        var id: String { key }
    }
    
    private func determineAttributes() -> [Attribute] {
        let seasonTitle = show.seasonTitles?[episode.seasonNumber]
        
        var attributes = [Attribute]()
        attributes.append(Attribute(key: show.typeOfSeasons.localizeCapSing, value: "\(seasonTitle != nil ? "\(seasonTitle!): " : "")\(episode.seasonNumber)"))
        attributes.append(Attribute(key: NSLocalizedString("Episode", comment: "").capitalized, value: "\(episode.numberInSeason)"))
        attributes.append(Attribute(key: NSLocalizedString("overall", comment: "").capitalizeFirstLetter(), value: "\(episode.numberInSeries)"))
        attributes.append(Attribute(key: NSLocalizedString("airdate", comment: "").capitalized, value: episode.airdate.written()))
        
        if let runtime = episode.runtimeDescription() {
            attributes.append(Attribute(key: NSLocalizedString("runtime", comment: "").capitalized, value: runtime))
        }
        
        if let directors = episode.directors {
            let key: String = "director".localizeWithFormat(quantity: directors.count).capitalized
            attributes.append(Attribute(key: key, value: directors.map { $0.fullName }.joined(separator: NSLocalizedString(" and ", comment: ""))))
        }
        
        if let writers = episode.writers {
            let key: String = "writer".localizeWithFormat(quantity: writers.count).capitalized
            attributes.append(Attribute(key: key, value: writers.map { $0.fullName }.joined(separator: NSLocalizedString(" and ", comment: ""))))
        }
        
        if let discInfo = episode.discInfo {
            let discLocation = "\(self.show.typeOfSeasons.localizeCapSing) \(discInfo.season), \(NSLocalizedString("disc", comment: "")) \(discInfo.disc), \(NSLocalizedString("Episode", comment: "subtitle (doesn't get a number preceding)")) \(discInfo.episode)"
            
            attributes.append(Attribute(key: NSLocalizedString("disc location", comment: "").capitalizeFirstLetter(), value: "\(discLocation.uppercased().first!)\(String(discLocation.lowercased().dropFirst()))"))
        }
        
        if let prevEp = show.episodes.before(episode) {
            attributes.append(Attribute(key: NSLocalizedString("previous", comment: "").capitalized, value: prevEp.title))
        }
        
        if let nextEp = show.episodes.after(episode) {
            attributes.append(Attribute(key: NSLocalizedString("next", comment: "").capitalized, value: nextEp.title))
        }
        
        if let characters = episode.characters {
            let key = "character".localizeWithFormat(quantity: characters.count).capitalized
            var value: String = ""
            
//            for (character, actor) in characters.sorted(by: { // sort by actor's last name
//                ($0.value.split(separator: " ").last ?? "") < ($1.value.split(separator: " ").last ?? "")
//            }) {
//                value += "\(actor) \(NSLocalizedString("as", comment: "")) \(character)\n"
//            }
            for character in characters.sorted(by: {
//                ($0.actor.getName().split(separator: " ").last ?? "").lowercased() < ($1.actor.split(separator: " ").last ?? "").lowercased()
                $0.actor < $1.actor
            }) {
//                value += "\(character.actor) \(NSLocalizedString(" as ", comment: "")) \(character.character)\n"
                value += "\(String(format: NSLocalizedString("%@ as %@", comment: ""), character.actor.fullName, character.character.fullName))\n"
            }
            attributes.append(Attribute(key: key, value: value))
        }
        
        return attributes
    }
}

//struct EpisodeDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        EpisodeDetailView()
//    }
//}

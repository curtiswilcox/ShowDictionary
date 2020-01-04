//
//  DoctorView.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 12/23/19.
//  Copyright © 2019 wilcoxcurtis. All rights reserved.
//

import SwiftUI

struct DoctorView: View {
    let show: Show
    
    var body: some View {
        List(getDoctors(), id: \.self) { doctor in
            NavigationLink(destination: EpisodeChooserView(navTitle: "\(String(format: NSLocalizedString("Episodes with %@", comment: ""), self.localizeDoctor(doctor, lower: true)))", show: self.show, episodes: self.show.episodes.filter { $0.doctors!.contains(doctor) })) {
                VStack(alignment: .leading) {
                    Text(self.localizeDoctor(doctor))
                    SubText("episode".localizeWithFormat(quantity: self.getNumEps(doctor)))
                }
            }
        }
        .navigationBarTitle("doctor".localizeWithFormat(quantity: 2).capitalized)
    }
    
    private func getDoctors() -> [String] {
        let doctors = show.episodes!.map { $0.doctors! }.reduce([], +)
        return Set<String>(doctors).sorted(by: { (first, second) in
            let formatter = NumberFormatter()
            formatter.numberStyle = .spellOut
            formatter.locale = Locale(identifier: "en")
            
            let firstNum = formatter.number(from: first.lowercased())
            let secondNum = formatter.number(from: second.lowercased())
            
            if let f = firstNum, let s = secondNum { return Int(truncating: f) < Int(truncating: s) }
            if let f = firstNum, second.lowercased() == "war" {
                return Int(truncating: f) < 12
            }
            if first.lowercased() == "war", let s = secondNum {
                return Int(truncating: s) >= 12
            }
            return true
        })
    }
    
    private func getNumEps(_ doctor: String) -> Int {
        return show.episodes.filter { $0.doctors!.contains(doctor) }.count
    }
    
    private func localizeDoctor(_ doctor: String, lower: Bool = false) -> String {
        guard doctor.lowercased() != "war" else {
            let localized = NSLocalizedString("The War Doctor", comment: "")
            if lower {
                return localized.first!.lowercased() + localized.dropFirst()
            } else {
                return localized
            }
        }
        
        var the: String
        
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.numberStyle = .spellOut
        
        let number = formatter.number(from: doctor.lowercased())!
        if number != 13 {
            the = NSLocalizedString("the (masculine)", comment: "")
        } else {
            the = NSLocalizedString("the (feminine)", comment: "")
        }
        the = (lower ? the : the.capitalized)
        return "\(the) \(getOrdinal(doctor)) \("doctor".localizeWithFormat(quantity: 1).capitalized)"
    }
    
    private func getOrdinal(_ doctor: String) -> String {
        guard doctor.lowercased() != "war" else { return NSLocalizedString("The War Doctor", comment: "") }
        
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.numberStyle = .spellOut
        
        let number = formatter.number(from: doctor.lowercased())!
        formatter.locale = Locale.current
        formatter.numberStyle = .ordinal
        
        return formatter.string(from: number)!
    }
}

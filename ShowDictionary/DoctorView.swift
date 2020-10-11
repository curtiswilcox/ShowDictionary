//
//  DoctorView.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 12/23/19.
//  Copyright © 2019 wilcoxcurtis. All rights reserved.
//

import SwiftUI

struct DoctorView: View {
  @EnvironmentObject var show: Show
  @State var doctorSelected: (doctor: String?, showing: Bool) = (nil, false)
  
  var body: some View {
    ZStack {
      if let doctor = doctorSelected.doctor {
//        let navTitle = "\(String(format: NSLocalizedString("Episodes with %@", comment: ""), localizeDoctor(doctor, lower: true)))"
        let navTitle = String(format: NSLocalizedString("%@", comment: ""), localizeDoctor(doctor, lower: true)).capitalizeFirstLetter()
        let episodesToPass = self.show.episodes.filter { $0.doctors!.contains(doctor) }
        NavigationLink(destination: EpisodeChooserView(navTitle: navTitle, useSections: true, episodes: episodesToPass).environmentObject(show), isActive: $doctorSelected.showing) {
          EmptyView()
        }
      }
      GridView(doctorSelected: $doctorSelected)
    }
    .navigationBarTitle("doctor".localizeWithFormat(quantity: 2).capitalized)
  }
}

//extension View {
//  func Print(_ vars: Any...) -> some View {
//    for v in vars { print(v) }
//    return EmptyView()
//  }
//}

extension DoctorView {
  struct GridView: View {
    @EnvironmentObject var show: Show
    @Binding var doctorSelected: (doctor: String?, showing: Bool)
    
    var body: some View {
      GeometryReader { geometry in
        ScrollView {
          LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 20) {
            ForEach(getDoctors(show: show), id: \.self) { doctor in
              Button {
                doctorSelected = (doctor, true)
              } label: {
                let width = geometry.size.width / 2.5
                CardView(width: width, vertAlignment: .top, horizAlignment: .leading) {
                  Text(localizeDoctor(doctor))
                    .font(.callout)
                    .bold()
                    .foregroundColor(Color(UIColor.label))
                    .padding(.top)
                  if let actor = getActor(doctor: doctor, newWho: show.filename == "doctorwho") {
                    SubText(actor) // note for above: rather than `classicdoctorwho`
                  }
                  Spacer()
                  Divider()
                    .background(Color(UIColor.systemGray))
                    .frame(width: width / 3)
                    .padding(.all, 0)
                  SubText("episode".localizeWithFormat(quantity: getNumEps(show: show, doctor: doctor)))
                    .padding(.bottom)
                }
              }
            }
          }
          .padding(.horizontal)
        }
        .onAppear { doctorSelected = (nil, false) }
      }
    }
    
    func getActor(doctor: String, newWho: Bool = false) -> String? {
      switch (doctor.lowercased(), newWho) {
      case ("one", true): return "David Bradley"
      case ("one", _): return "William Hartnell"
      case ("two", _): return "Patrick Troughton"
      case ("three", _): return "Jon Pertwee"
      case ("four", _): return "Tom Baker"
      case ("five", _): return "Peter Davison"
      case ("six", _): return "Colin Baker"
      case ("seven", _): return "Sylvester McCoy"
      case ("eight", _): return "Paul McGann"
      case ("nine", _): return "Christopher Eccleston"
      case ("ten", _): return "David Tennant"
      case ("eleven", _): return "Matt Smith"
      case ("war", _): return "John Hurt"
      case ("twelve", _): return "Peter Capaldi"
      case ("thirteen", _): return "Jodie Whittaker"
      default: return nil
      }
    }
  }
}

fileprivate func getNumEps(show: Show, doctor: String) -> Int {
  return show.episodes.filter { $0.doctors!.contains(doctor) }.count
}

fileprivate func getDoctors(show: Show) -> [String] {
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

fileprivate func localizeDoctor(_ doctor: String, lower: Bool = false) -> String {
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

fileprivate func getOrdinal(_ doctor: String) -> String {
//  print("---------\(doctor)---------")
  guard doctor.lowercased() != "war" else { return NSLocalizedString("The War Doctor", comment: "") }
  
  let formatter = NumberFormatter()
  formatter.locale = Locale(identifier: "en")
  formatter.numberStyle = .spellOut
  
  let number = formatter.number(from: doctor.lowercased())!
  formatter.locale = Locale.current
  formatter.numberStyle = .ordinal
  
  return formatter.string(from: number)!
}

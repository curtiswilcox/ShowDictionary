//
//  ShowDictionaryApp.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 9/18/20.
//  Copyright © 2020 wilcoxcurtis. All rights reserved.
//

import CloudKit
//import CoreData
import SwiftUI

var signedIn: Bool = false

@available(iOS 14.0, *)
@main
struct ShowDictionaryApp: App {
//  @Environment(\.scenePhase) private var scenePhase
  
  var body: some Scene {
    WindowGroup {
      ContentView()
//        .environment(\.managedObjectContext, persistentContainer.viewContext)
    }
//    .onChange(of: scenePhase) { phase in
//      switch phase {
//      case .active:
//        print("Active scene!")
//      case .inactive:
//        print("Inactive scene!")
//      case .background:
//        print("Background!")
//        saveContext()
//      @unknown default:
//        fatalError("Uhh... fatal error in \(#file), line \(#line). Phase: \(phase).")
//      }
//    }
  }
  
//  var persistentContainer: NSPersistentContainer = {
//    let container = NSPersistentContainer(name: "ShowDictionary")
//    container.loadPersistentStores { _, error in
//      if let error = error as NSError? {
//        fatalError("Unresolved error :\(error), \(error.userInfo)")
//      }
//    }
//    return container
//  }()
  
  init() {
    connectToCloudKit()
  }
  
  private func connectToCloudKit() {
    NotificationCenter.default.addObserver(forName: .NSUbiquityIdentityDidChange, object: nil, queue: nil) { _ in
      self.getiCloudLoginStatus() {
        signedIn = $0
      }
    }
    
    self.getiCloudLoginStatus() {
      signedIn = $0
    }
  }
  
  private func getiCloudLoginStatus(completion: @escaping (Bool) -> ()) {
    CKContainer.default().accountStatus() { (status, error) in
      if status == .available {
        completion(true)
      } else {
        completion(false)
      }
    }
  }
  
//  func saveContext() {
//    let context = persistentContainer.viewContext
//    if context.hasChanges {
//      do {
//        try context.save()
//      } catch let error as NSError {
//        fatalError("Unresolved error \(error), \(error.userInfo)")
//      }
//    }
//  }
}

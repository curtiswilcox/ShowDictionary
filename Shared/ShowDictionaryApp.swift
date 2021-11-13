//
//  ShowDictionaryApp.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 9/18/20.
//  Copyright © 2020 wilcoxcurtis. All rights reserved.
//

import CloudKit
import SwiftUI

var signedIn: Bool = false

@main
struct ShowDictionaryApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
                .task { await connectToCloudKit() }
        }
    }
    
    private func connectToCloudKit() async {
        NotificationCenter.default.addObserver(forName: .NSUbiquityIdentityDidChange, object: nil, queue: nil) { _ in
            Task {
                signedIn = await getiCloudLoginStatus()
            }
        }
        
        signedIn = await getiCloudLoginStatus()
    }
        
    private func getiCloudLoginStatus() async -> Bool {
        do {
            return try await CKContainer.default().accountStatus() == .available
        } catch {
            return false
        }
    }
}

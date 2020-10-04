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

@available(iOS 14.0, *)
@main
struct ShowDictionaryApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
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
}

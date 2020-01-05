//
//  HostingController.swift
//  ShowDictionaryWatchOS Extension
//
//  Created by Curtis Wilcox on 1/3/20.
//  Copyright © 2020 wilcoxcurtis. All rights reserved.
//

import CloudKit
import WatchKit
import Foundation
import SwiftUI

var signedIn: Bool = false

class HostingController: WKHostingController<ContentView> {
    override var body: ContentView {
        return ContentView()
    }
    
    override init() {
        super.init()
        
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

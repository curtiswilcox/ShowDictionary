//
//  CKRecord.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 10/28/21.
//

import CloudKit
import Foundation

extension CKRecord {
    func getInt(field: String) -> Int? {
        guard let value = self[field] as? CVarArg else { return nil }
        return Int(String(format: "%@", value))
    }
    
    func getString(field: String) -> String? {
        guard let value = self[field] as? CVarArg else { return nil }
        return String(format: "%@", value)
    }
}

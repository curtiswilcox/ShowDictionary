//
//  Record.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 10/27/21.
//

import Foundation
import CloudKit.CKRecordID

typealias Record = (recordID: CKRecord.ID, filename: String, code: Int)

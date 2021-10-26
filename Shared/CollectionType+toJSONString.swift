//
//  CollectionType+toJSONString.swift
//  ShowDictionaryMac
//
//  Created by Curtis Wilcox on 6/1/19.
//  Copyright © 2019 wilcoxcurtis. All rights reserved.
//

import Foundation
import Swift

extension Collection where Iterator.Element == [String: Any] {
    func toJSONString(options: JSONSerialization.WritingOptions = .prettyPrinted) -> String {
        if let arr = self as? [[String: Any]],
            let dat = try? JSONSerialization.data(withJSONObject: arr, options: options),
            let str = String(data: dat, encoding: .utf8) {
            return str
        }
        return "[]"
    }
}

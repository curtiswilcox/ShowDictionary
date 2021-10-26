//
//  URL+ExpressibleByStringLiteral.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 10/25/21.
//  Copyright © 2021 wilcoxcurtis. All rights reserved.
//

import Foundation

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: StaticString) {
        self.init(string: "\(value)")!
    }
}

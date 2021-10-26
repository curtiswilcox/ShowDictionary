//
//  Observable.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 10/26/21.
//  Copyright © 2021 wilcoxcurtis. All rights reserved.
//

import Foundation

protocol Observable: Comparable, CustomStringConvertible, Decodable, Identifiable {
    func validItem(searchText: String) -> Bool
}


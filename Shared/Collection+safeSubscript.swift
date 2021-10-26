//
//  Collection+safeSubscript.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 1/1/19.
//  Copyright © 2019 Curtis Wilcox. All rights reserved.
//

import Foundation

extension Collection {
	subscript(safe index: Index) -> Element? {
		return indices.contains(index) ? self[index] : nil
	}
}

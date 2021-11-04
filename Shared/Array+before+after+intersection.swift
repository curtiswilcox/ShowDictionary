//
//  Array+before+after.swift
//  ShowDictionary
//
//  Created by Curtis Wilcox on 2/2/19.
//  Copyright © 2019 Curtis Wilcox. All rights reserved.
//

import Foundation

extension Array where Element: Comparable {
	func before(_ e: Element) -> Element? {
		guard let index = self.firstIndex(where: { $0 == e }) else {
			return nil
		}
		guard let element = self[safe: index - 1] else {
			return nil
		}
		return element
	}
	
	func after(_ e: Element) -> Element? {
		guard let index = self.firstIndex(where: { $0 == e }) else {
			return nil
		}
		guard let element = self[safe: index + 1] else {
			return nil
		}
		return element
	}
}

//extension Array where Element: Equatable {
//    func intersecton(other rhs: [Element]) -> [Element] {
//        filter {
//            rhs.contains($0)
//        }
//    }
//}

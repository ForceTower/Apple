//
//  Sequence+Extensions.swift
//  UNES
//
//  Created by João Santos Sena on 16/07/23.
//

import Foundation

extension Sequence {
    func distinct(by selector: (Element) -> any Hashable) -> [Element] {
        var seen = Set<AnyHashable>()
        var result = [Element]()
        
        forEach { element in
            let key = selector(element)
            let insertion = seen.insert(key)
            if insertion.inserted {
                result.append(element)
            }
        }
        
        return result
    }
}


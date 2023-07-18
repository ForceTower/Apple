//
//  Class+Extensions.swift
//  UNES
//
//  Created by João Santos Sena on 17/07/23.
//

import Foundation

extension ClassEntity {
    func isInFinal() -> Bool {
        let operation = partialScore
        guard operation != -1 else { return false }
        return operation >= 3.0 && operation <= 6.97
    }
}

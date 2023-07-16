//
//  Grade+Extensions.swift
//  UNES
//
//  Created by João Santos Sena on 15/07/23.
//

import Foundation

extension GradeEntity {
    func hasGrade() -> Bool {
        guard let grade = grade?.trimmingCharacters(in: .whitespacesAndNewlines) else { return false }
        // Me from the past was prettry criterious about these, ill trust my past self :^)
        return grade != "Não Divulgada" && grade != "-" && grade != "--" && grade != "*" && grade != "**" && grade != "-1"
    }
    
    func doubleValue() -> Double? {
        guard let string = grade?.trimmingCharacters(in: .whitespaces) else { return nil }
        let replaced = string.replacingOccurrences(of: ",", with: ".")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "*", with: "")
        return Double(replaced)
    }
}

//
//  DisciplineListSupport.swift
//  UNES
//
//  Created by João Santos Sena on 17/07/23.
//

import Foundation

enum DisciplineHelperData {
    case header(ClassEntity)
    case score(ClassEntity,GradeEntity)
    case final(ClassEntity)
    case mean(ClassEntity)
    case groupName(ClassEntity,String)
    case emptySemester(SemesterEntity)
    case divider
}

class DisciplineListSupport {
    static func transformClassesIntoUiElements(
        semesters: [SemesterEntity],
        classes: [ClassEntity]
    ) -> [[DisciplineHelperData]] {
        let semesters = semesters.sorted { $0.id > $1.id }
        let completedMap = Dictionary(grouping: classes, by: \.semesterId).mapValues { disciplines in
            var result = [DisciplineHelperData]()
            let sorted = disciplines.sorted { a, b in
                let aName = a.discipline?.name ?? ""
                let bName = b.discipline?.name ?? ""
                return aName < bName
            }
            
            for (index, clazz) in sorted.enumerated() {
                if index != 0 {
                    result.append(.divider)
                }
                
                result.append(.header(clazz))
                
                let grades = clazz.grades?.allObjects as? [GradeEntity] ?? []
                let groupings = Dictionary(grouping: grades, by: \.grouping)
                if groupings.keys.count <= 1 {
                    grades.sorted { ($0.name ?? "") < ($1.name ?? "") }.forEach { grade in
                        result.append(.score(clazz, grade))
                    }
                } else {
                    groupings.sorted { $0.key! < $1.key! }.forEach { (_, value) in
                        if !value.isEmpty {
                            let sample = value[0]
                            result.append(.groupName(clazz, sample.groupingName!))
                            value.sorted { $0.name! < $1.name! }.forEach { grade in
                                result.append(.score(clazz, grade))
                            }
                        }
                    }
                }
                
                if clazz.isInFinal() {
                    result.append(.final(clazz))
                }
                result.append(.mean(clazz))
            }
            return result
        }
        
        return semesters.map { it in
            completedMap[it.id] ?? [.emptySemester(it)]
        }
    }
}

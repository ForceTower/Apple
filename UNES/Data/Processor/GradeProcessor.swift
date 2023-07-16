//
//  GradeProcessor.swift
//  UNES
//
//  Created by João Santos Sena on 15/07/23.
//

import Foundation
import Arcadia
import CoreData

class GradeProcessor {
    static func process(
        evaluations: [ClassEvaluation],
        forClass clazz: ClassEntity,
        notifying notify: Bool,
        withContext context: NSManagedObjectContext,
        saveAfterChanges save: Bool
    ) throws {
        guard let classId = clazz.id else {
            print("Write this one to crashlytics as a non fatal. Should not happen")
            return
        }
        evaluations.forEach { evaluation in
            let grades = evaluation.grades
            // For now I dont care about repeated names as this names comes from Arcadia
            // Thus, no deduplicating is needed
            grades.forEach { grade in
                print("Attempting to insert \(evaluation.name ?? "unamed") | \(grade.name) [\(grade.value ?? -1)]")
                
                let current = fetchCurrentGrade(classId: classId, name: "\(grade.nameShort) - \(grade.name)", grouping: evaluation.name?.hash ?? 0, context: context)
                
                if current == nil {
                    print("It's a new grade")
                    var notified = 1
                    if grade.value != nil { notified = 3 }
                    
                    let entity = GradeEntity(context: context)
                    entity.classId = classId
                    entity.name = "\(grade.nameShort.trimmingCharacters(in: .whitespaces)) - \(grade.name.trimmingCharacters(in: .whitespaces))"
                    entity.notified = Int16(notified)
                    if let grade = grade.value {
                        entity.grade = String(grade)
                    } else {
                        entity.grade = nil
                    }
                    if let name = evaluation.name?.trimmingCharacters(in: .whitespaces) {
                        entity.grouping = String(name.hash)
                    } else {
                        entity.grouping = "0"
                    }
                    entity.groupingName = evaluation.name?.trimmingCharacters(in: .whitespaces) ?? "Notas"
                    entity.date = grade.date?.trimmingCharacters(in: .whitespaces)
                    
                    clazz.grades?.adding(entity)
                } else {
                    // Shouldn't be needed but swift doesnt like the if else statment :^)
                    let current = current!
                    var shouldUpdate = true
                    print("Updating existing grade.")
                    var score = ""
                    if let grade = grade.value { score = String(grade) }
                    
                    if current.hasGrade() && grade.hasGrade() && score != current.grade {
                        current.notified = 4
                        current.grade = score
                        current.date = grade.date?.trimmingCharacters(in: .whitespaces)
                    } else if !current.hasGrade() && grade.hasGrade() {
                        current.notified = 3
                        current.grade = score
                        current.date = grade.date?.trimmingCharacters(in: .whitespaces)
                    } else if !current.hasGrade() && !grade.hasGrade() && current.date != grade.date {
                        current.notified = 2
                        current.date = grade.date?.trimmingCharacters(in: .whitespaces)
                    } else {
                        shouldUpdate = false
                        print("No changes detected between updates at \(current.name ?? "unamed") \(current.grouping ?? "...") and \(grade.name) \(evaluation.name?.hash ?? 0)")
                    }
                    
                    if current.groupingName != evaluation.name {
                        shouldUpdate = true
                        current.groupingName = evaluation.name?.trimmingCharacters(in: .whitespaces) ?? "Notas"
                    }
                    
                    // This is a tricky condition and i'm half a sleep
                    if !notify && shouldUpdate {
                        current.notified = 0
                    }
                }
            }
        }
        if save {
            try context.save()
        }
    }
    
    private static func fetchCurrentGrade(classId: String, name: String, grouping: Int, context: NSManagedObjectContext) -> GradeEntity? {
        let request = GradeEntity.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "classId = %@ AND name = %@ AND grouping = %@", classId, name, String(grouping))
        
        return try? context.fetch(request).first
    }
}

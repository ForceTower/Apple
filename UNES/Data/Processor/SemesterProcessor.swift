//
//  SemesterProcessor.swift
//  UNES
//
//  Created by João Santos Sena on 15/07/23.
//

import Foundation
import Arcadia
import CoreData

class SemesterProcessor {
    // TODO: Refactor this to be injected
    static func process(semesters: [Semester], withContext context: NSManagedObjectContext) throws {
        semesters.forEach { semester in
            let entity = SemesterEntity(context: context)
            entity.id = Int64(semester.id)
            entity.name = semester.code.trimmingCharacters(in: .whitespacesAndNewlines)
            entity.codename = semester.description.trimmingCharacters(in: .whitespacesAndNewlines)
            entity.start = try? Date(semester.start, strategy: .iso8601)
            entity.end = try? Date(semester.end, strategy: .iso8601)
        }
        try context.save()
    }
}

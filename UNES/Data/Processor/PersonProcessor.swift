//
//  PersonProcessor.swift
//  UNES
//
//  Created by João Santos Sena on 15/07/23.
//

import Foundation
import CoreData
import Arcadia

class PersonProcessor {
    // TODO: Refactor this to be injected
    static func process(person: Person, withContext context: NSManagedObjectContext) throws {
        let request = ProfileEntity.fetchRequest()
        request.fetchLimit = 1
        
        let current = try context.fetch(request).first ?? ProfileEntity(context: context)
        current.id = Int64(person.id)
        current.name = person.name.trimmingCharacters(in: .whitespacesAndNewlines)
        current.email = person.email?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        try context.save()
    }
}

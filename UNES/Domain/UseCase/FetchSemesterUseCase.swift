//
//  FetchSemesterUseCase.swift
//  UNES
//
//  Created by João Santos Sena on 29/07/23.
//

import Foundation
import CoreData
import Arcadia

class FetchSemesterUseCase {
    func execute(forSemesterId semesterId: Int64) async {
        let context = UNESPersistenceController.shared.container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        let (username, password) = context.performAndWait {
            let access = UNESPersistenceController.shared.getAccess(context: context)
            return (access?.username, access?.password)
        }
        guard let username = username, let password = password else {
            print("Access not found.")
            return
        }
        
        let arcadia = Arcadia(username: username, password: password)
        do {
            let person = try await arcadia.login().get()
            let result = try await arcadia.grades(forProfile: person.id, atSemester: Int(semesterId)).get()
            try context.performAndWait {
                try DisciplineProcessor.process(disciplines: result, atSemester: semesterId, markNotified: true, withContext: context)
                try context.save()
            }
        } catch(let err) {
            print("Failed to fetch semester data. \(err.localizedDescription)")
        }
    }
}

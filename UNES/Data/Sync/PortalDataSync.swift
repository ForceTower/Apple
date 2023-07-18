//
//  PortalDataSync.swift
//  UNES
//
//  Created by João Santos Sena on 18/07/23.
//

import Foundation
import CoreData
import Arcadia
import FirebaseCrashlytics

class PortalDataSync {
    func update(
        username: String,
        password: String,
        context: NSManagedObjectContext
    ) async -> Bool {
        let arcadia = Arcadia(username: username, password: password)
        do {
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            let person = try await arcadia.login().get()
            
            let messages = try await arcadia.messages(forProfile: person.id).get()
            UNESPersistenceController.shared.save(messages: messages.messages)
            
            let semesters = try await arcadia.semesters(forProfile: person.id).get()
            try SemesterProcessor.process(semesters: semesters, withContext: context)
            
            if let currentSemester = semesters.max(by: { $0.id < $1.id }) {
                let grades = try await arcadia.grades(forProfile: person.id, atSemester: currentSemester.id).get()
                try DisciplineProcessor.process(
                    disciplines: grades,
                    atSemester: Int64(currentSemester.id),
                    notifying: false,
                    withContext: context)
            }
            return true
        } catch (let error) {
            Crashlytics.crashlytics().log("Failed with error \(error.localizedDescription)")
            Crashlytics.crashlytics().record(error: error)
            
            if let error = error.asAFError, let code = error.responseCode {
                if code == 401 {
                    onAuthenticationFailed(context: context)
                }
            }
            
            return false
        }
    }
    
    private func onAuthenticationFailed(context: NSManagedObjectContext) {
        try? UNESPersistenceController.shared.deleteAll(context: context)
    }
}

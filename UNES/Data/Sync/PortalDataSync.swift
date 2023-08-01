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
        password: String
    ) async -> Bool {
        let arcadia = Arcadia(username: username, password: password)
        do {
            let context = UNESPersistenceController.shared.container.newBackgroundContext()
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            let person = try await arcadia.login().get()
            
            let messages = try await arcadia.messages(forProfile: person.id).get()
            let new = UNESPersistenceController.shared.save(messages: messages.messages, markingNotified: true)
            notifyMessages(new)
            
            let semesters = try await arcadia.semesters(forProfile: person.id).get()
            try SemesterProcessor.process(semesters: semesters, withContext: context)
            
            if let currentSemester = semesters.max(by: { $0.id < $1.id }) {
                let grades = try await arcadia.grades(forProfile: person.id, atSemester: currentSemester.id).get()
                try DisciplineProcessor.process(
                    disciplines: grades,
                    atSemester: Int64(currentSemester.id),
                    markNotified: false,
                    withContext: context)
                notifyGrades(context: context)
            }
            return true
        } catch (let error) {
            Crashlytics.crashlytics().log("Failed with error \(error.localizedDescription)")
            Crashlytics.crashlytics().record(error: error)
            
            if let error = error.asAFError, let code = error.responseCode {
                if code == 401 {
                    onAuthenticationFailed()
                }
            }
            
            return false
        }
    }
    
    private func onAuthenticationFailed() {
        try? UNESPersistenceController.shared.deleteAll()
    }
    
    private func notifyMessages(_ messages: [MessageEntity]) {
        messages.forEach { message in
            NotificationManager.shared.createNotification(forMessage: message)
        }
    }
    
    private func notifyGrades(context: NSManagedObjectContext) {
        let request = GradeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "notified != %@", 0)
        let grades = (try? context.fetch(request)) ?? []
        grades.forEach { grade in
            NotificationManager.shared.createNotification(forGrade: grade)
        }
        try? context.save()
    }
}

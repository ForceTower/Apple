//
//  LoginUseCase.swift
//  UNES
//
//  Created by João Santos Sena on 12/07/23.
//

import Combine
import CoreData
import Arcadia
import FirebaseCrashlytics

class LoginUseCase {
    func execute(username: String, password: String) -> AsyncThrowingStream<PortalAuthProgress, Error> {
        let arcadia = Arcadia(username: username, password: password)

        return AsyncThrowingStream<PortalAuthProgress, Error> { continuation in
            Task {
                do {
                    continuation.yield(.handshake)
                    
                    let person = try await arcadia.login().get()
                    continuation.yield(.fetchedUser(person: person))
                    
                    let messages = try await arcadia.messages(forProfile: person.id).get()
                    UNESPersistenceController.shared.save(messages: messages.messages, markingNotified: true)
                    continuation.yield(.fetchedMessages)
                    
                    let semesters = try await arcadia.semesters(forProfile: person.id).get()
                    let context = UNESPersistenceController.shared.container.newBackgroundContext()
                    context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                    try SemesterProcessor.process(semesters: semesters, withContext: context)
                    
                    continuation.yield(.fetchedSemesterInfo)
                    print(semesters)
                    if let currentSemester = semesters.max(by: { $0.id < $1.id }) {
                        print("Current semester is \(currentSemester)")
                        let grades = try await arcadia.grades(forProfile: person.id, atSemester: currentSemester.id).get()
                        try context.performAndWait {
                            try DisciplineProcessor.process(
                                disciplines: grades,
                                atSemester: Int64(currentSemester.id),
                                markNotified: true,
                                withContext: context)
                        }
                        
                        UNESPersistenceController.shared.saveAccess(username, password)
                        continuation.yield(.fetchedGrades)
                        continuation.finish()
                    } else {
                        let error = NSError(domain: "authentication", code: 7, userInfo: [
                            NSLocalizedDescriptionKey: "Nenhum semestre foi encontrado"
                        ])
                        continuation.finish(throwing: PortalAuthError.otherError(underlyingError: error))
                    }
                } catch (let error) {
                    print("Failed with error \(error.localizedDescription)")
                    print(error)
                    Crashlytics.crashlytics().log("Failed to run login")
                    Crashlytics.crashlytics().record(error: error)
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}

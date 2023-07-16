//
//  LoginUseCase.swift
//  UNES
//
//  Created by João Santos Sena on 12/07/23.
//

import Combine
import CoreData
import Arcadia

class LoginUseCase {
    func execute(username: String, password: String) -> AsyncThrowingStream<PortalAuthProgress, Error> {
        let arcadia = Arcadia(username: username, password: password)

        return AsyncThrowingStream<PortalAuthProgress, Error> { continuation in
            Task {
                do {
                    continuation.yield(.handshake)
                    
                    let person = try await arcadia.login().get()
                    UNESPersistenceController.shared.saveAccess(username, password)
                    continuation.yield(.fetchedUser(person: person))
                    
                    let messages = try await arcadia.messages(forProfile: person.id).get()
                    UNESPersistenceController.shared.save(messages: messages.messages)
                    continuation.yield(.fetchedMessages)
                    
                    let semesters = try await arcadia.semesters(forProfile: person.id).get()
                    let context = UNESPersistenceController.shared.container.newBackgroundContext()
                    context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                    try SemesterProcessor.process(semesters: semesters, withContext: context)
                    
                    continuation.yield(.fetchedSemesterInfo)
                    if let currentSemester = semesters.max(by: { a, b in a.id > b.id }) {
                        print("Current semester is \(currentSemester)")
                        let grades = try await arcadia.grades(forProfile: person.id, atSemester: currentSemester.id).get()
                        try DisciplineProcessor.process(
                            disciplines: grades,
                            atSemester: Int64(currentSemester.id),
                            notifying: false,
                            withContext: context)
                        
                        continuation.yield(.fetchedGrades)
                        continuation.finish()
                    } else {
                        continuation.finish(throwing: PortalAuthError.otherError)
                    }
                } catch (let error) {
                    print("Failed with error \(error.localizedDescription)")
                    print(error)
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}

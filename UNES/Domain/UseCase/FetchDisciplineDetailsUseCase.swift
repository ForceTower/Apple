//
//  FetchDisciplineDetailsUseCase.swift
//  UNES
//
//  Created by João Santos Sena on 29/07/23.
//

import Foundation
import Arcadia
import CoreData

class FetchDisciplineDetailsUseCase {
    func fetch(forGroupId groupId: Int64) async {
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
        let result = await arcadia.lectures(for: Int(groupId), limit: 0, offset: 0)
        switch(result) {
        case .success(let lectures):
            context.performAndWait {
                try? LectureProcessor.process(groupId: groupId, lectures: lectures, withContext: context)
                try? context.save()
            }
            print("Updated data for \(groupId)")
        case .failure(let error):
            print("Failed to run discipline update. \(error.localizedDescription)")
        }
    }
}

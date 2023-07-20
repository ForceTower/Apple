//
//  ScheduleViewModel.swift
//  UNES
//
//  Created by João Santos Sena on 16/07/23.
//

import Foundation
import CoreData
import FirebaseCrashlytics
import UIKit

enum ScheduleSections {
    case block([ProcessedClassLocation])
    case list([ProcessedClassLocation])
}

class ScheduleViewModel {
    @Published private(set) var schedule = [Int16: [ProcessedClassLocation]]()
    @Published private(set) var built = [ProcessedClassLocation]()
    @Published private(set) var disciplineColors = [String: Int]()
    @Published private(set) var sections = [ScheduleSections]()
    @Published private(set) var refreshing = false
    
    func registerListener() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contextObjectsDidSave),
            name: Notification.Name.NSManagedObjectContextDidSave,
            object: UNESPersistenceController.shared.container.viewContext)
    }
    
    func fetchSchedule() {
        let context = UNESPersistenceController.shared.container.viewContext
        let request = ClassLocationEntity.fetchRequest()
        let locations = try? context.fetch(request)
        updateData(locations ?? [])
    }
    
    @objc func contextObjectsDidSave(_notification: Notification) {
        fetchSchedule()
    }
    
    private func updateData(_ locations: [ClassLocationEntity]) {
        schedule = ScheduleBlockSupport.createMap(locations)
        let block = ScheduleBlockSupport.buildDisplayBlock(schedule)
        let list = ScheduleBlockSupport.buildDisplayList(schedule)

        sections = [
            ScheduleSections.block(block.1),
            ScheduleSections.list(list)
        ]

        disciplineColors = block.0
        built = block.1
    }
    
    func refreshData() {
        if refreshing { return }
        do {
            let context = UNESPersistenceController.shared.container.viewContext
            let access = try context.fetch(AccessEntity.fetchRequest()).first
            guard let access = access,
                  let username = access.username,
                  let password = access.password else {
                return
            }
            refreshing = true
            Task {
                let result = await PortalDataSync().update(username: username, password: password)
                print("Finished executing \(result)")
                DispatchQueue.main.async { [weak self] in
                    self?.refreshing = false
                }
            }
        } catch (let error) {
            Crashlytics.crashlytics().log("Failed to refresh")
            Crashlytics.crashlytics().record(error: error)
        }
    }
}

//
//  MessagesViewModel.swift
//  UNES
//
//  Created by João Santos Sena on 15/07/23.
//

import Combine
import Foundation
import Firebase

class MessagesViewModel {
    @Published private(set) var messages: [MessageEntity] = []
    @Published private(set) var refreshing = false
    
    func registerListener() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contextObjectsDidSave),
            name: Notification.Name.NSManagedObjectContextDidSave,
            object: UNESPersistenceController.shared.container.viewContext)
    }
    
    func loadMessages() {
        let context = UNESPersistenceController.shared.container.viewContext
        let request = MessageEntity.fetchRequest()
        request.sortDescriptors = [.init(key: "timestamp", ascending: false)]
        guard let result = try? context.fetch(request) else { return }
        messages = result
    }
    
    @objc func contextObjectsDidSave(_notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.loadMessages()
        }
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
                    self?.loadMessages()
                }
            }
        } catch (let error) {
            Crashlytics.crashlytics().log("Failed to refresh")
            Crashlytics.crashlytics().record(error: error)
            DispatchQueue.main.async { [weak self] in
                self?.refreshing = false
            }
        }
    }
}

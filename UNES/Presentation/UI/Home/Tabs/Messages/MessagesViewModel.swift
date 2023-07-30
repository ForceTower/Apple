//
//  MessagesViewModel.swift
//  UNES
//
//  Created by João Santos Sena on 15/07/23.
//

import Combine
import Foundation

class MessagesViewModel {
    @Published private(set) var messages: [MessageEntity] = []
    
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
}

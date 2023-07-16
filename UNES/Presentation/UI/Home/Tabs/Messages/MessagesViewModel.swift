//
//  MessagesViewModel.swift
//  UNES
//
//  Created by João Santos Sena on 15/07/23.
//

import Combine

class MessagesViewModel {
    @Published private(set) var messages: [MessageEntity] = []
    
    func loadMessages() {
        let context = UNESPersistenceController.shared.container.viewContext
        let request = MessageEntity.fetchRequest()
        request.sortDescriptors = [.init(key: "timestamp", ascending: false)]
        guard let result = try? context.fetch(request) else { return }
        messages = result
    }
}

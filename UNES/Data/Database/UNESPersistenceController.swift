//
//  UNESPersistenceController.swift
//  UNES
//
//  Created by João Santos Sena on 13/07/23.
//

import CoreData
import Arcadia

class UNESPersistenceController {
    static let shared = UNESPersistenceController()
    
    let container: NSPersistentContainer
    
    init(memory: Bool = false) {
        container = NSPersistentContainer(name: "UNESDataModel")
        if memory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { desc, err in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            if let error = err {
                print("Failed to initialize CoreData. Error \(error)")
            } else {
                print("Loaded CoreData")
            }
        }
    }
    
    func saveAccess(_ username: String, _ password: String) {
        let context = UNESPersistenceController.shared.container.newBackgroundContext()
        
        let access = AccessEntity(context: context)
        access.username = username
        access.password = password
        
        try? context.save()
    }
    
    func save(messages: [Message], markingNotified notified: Bool = false) {
        let context = UNESPersistenceController.shared.container.newBackgroundContext()
        
        messages.forEach { message in
            let entity = MessageEntity(context: context)
            entity.id = Int64(message.id)
            entity.content = message.content.replacingOccurrences(of: "\\n", with: "\n").replacingOccurrences(of: "\\r", with: "\r")
            entity.senderName = message.sender
            entity.senderProfile = Int16(message.senderType)
            entity.timestamp = try? Date(message.timestamp, strategy: .iso8601)
            entity.notified = notified
            entity.processingTime = Date()
            entity.html = false
            entity.hashMessage = Int64(message.content.replacingOccurrences(of: "\\n", with: "\n").lowercased().hash)
            entity.discipline = message.discipline?.discipline
            entity.codeDiscipline = message.discipline?.code
        }
        
        try? context.save()
    }
}


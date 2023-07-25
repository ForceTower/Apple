//
//  DisciplineDetailsViewModel.swift
//  UNES
//
//  Created by João Santos Sena on 20/07/23.
//

import Combine
import CoreData

class DisciplineDetailsViewModel {
    private let classId: Int64
    
    @Published private(set) var clazz: ClassGroupEntity? = nil
    
    init(classId: Int64) {
        self.classId = classId
    }
    
    func setup() {
        func registerListener() {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(contextObjectsDidSave),
                name: Notification.Name.NSManagedObjectContextDidSave,
                object: UNESPersistenceController.shared.container.viewContext)
        }
    }
    
    func fetchData() {
        let context = UNESPersistenceController.shared.container.viewContext
        let request = ClassGroupEntity.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id = %ld", classId)
        
        let result = try? context.fetch(request).first
        if let result = result {
            clazz = result
        }
    }
    
    @objc func contextObjectsDidSave(_notification: Notification) {
        fetchData()
    }
    
    func onClose() {
        NotificationCenter.default.removeObserver(self)
    }
}

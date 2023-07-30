//
//  DisciplineMaterialsViewModel.swift
//  UNES
//
//  Created by João Santos Sena on 29/07/23.
//

import Foundation

class DisciplineMaterialsViewModel {
    private let groupId: Int64
    @Published private(set) var materials: [ClassMaterialEntity] = []
    
    init(groupId: Int64) {
        self.groupId = groupId
    }
    
    func registerListener() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contextObjectsDidSave),
            name: Notification.Name.NSManagedObjectContextDidSave,
            object: UNESPersistenceController.shared.container.viewContext)
    }
    
    func loadMaterials() {
        let context = UNESPersistenceController.shared.container.viewContext
        let request = ClassMaterialEntity.fetchRequest()
        request.predicate = NSPredicate(format: "groupId = %ld", groupId)
        guard let result = try? context.fetch(request) else { return }
        materials = result
    }
    
    @objc func contextObjectsDidSave(_notification: Notification) {
        loadMaterials()
    }
    
    func onClose() {
        NotificationCenter.default.removeObserver(self)
    }
}

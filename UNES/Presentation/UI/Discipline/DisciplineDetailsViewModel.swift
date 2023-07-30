//
//  DisciplineDetailsViewModel.swift
//  UNES
//
//  Created by João Santos Sena on 20/07/23.
//

import Combine
import CoreData

class DisciplineDetailsViewModel {
    let classId: Int64
    private let fetchDetails: FetchDisciplineDetailsUseCase
    
    @Published private(set) var clazz: ClassGroupEntity? = nil
    
    init(classId: Int64, fetchDetails: FetchDisciplineDetailsUseCase) {
        self.classId = classId
        self.fetchDetails = fetchDetails
    }
    
    func updateData() {
        Task {
            await fetchDetails.fetch(forGroupId: classId)
        }
    }
    
    func setup() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contextObjectsDidSave),
            name: Notification.Name.NSManagedObjectContextDidSave,
            object: UNESPersistenceController.shared.container.viewContext)
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
        DispatchQueue.main.async { [weak self] in
            self?.fetchData()
        }
    }
    
    func onClose() {
        NotificationCenter.default.removeObserver(self)
    }
}

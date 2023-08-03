//
//  DisciplinesViewModel.swift
//  UNES
//
//  Created by João Santos Sena on 17/07/23.
//

import Foundation
import CoreData

class DisciplinesViewModel {
    private let fetchSemester: FetchSemesterUseCase
    
    init(fetchSemester: FetchSemesterUseCase) {
        self.fetchSemester = fetchSemester
    }
    
    @Published private(set) var disciplinesMapped = [[DisciplineHelperData]]()
    private(set) var allSemesters = [SemesterEntity]()
    
    private var semesterTask: Task<Void, Never>? = nil
    
    func registerListener() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contextObjectsDidSave),
            name: Notification.Name.NSManagedObjectContextDidSave,
            object: UNESPersistenceController.shared.container.viewContext)
    }
    
    func fetchData() {
        let context = UNESPersistenceController.shared.container.viewContext
        let semesters = try? context.fetch(SemesterEntity.fetchRequest())
        let classes = try? context.fetch(ClassEntity.fetchRequest())
        
        disciplinesMapped = DisciplineListSupport.transformClassesIntoUiElements(semesters: semesters ?? [], classes: classes ?? [])
        allSemesters = (semesters ?? []).sorted { $0.id > $1.id }
    }
    
    func loadSemester(_ semester: SemesterEntity) {
        semesterTask?.cancel()
        let id = semester.id
        semesterTask = Task {
            await fetchSemester.execute(forSemesterId: id)
            DispatchQueue.main.async { [weak self] in
                self?.fetchData()
            }
        }
    }
    
    @objc func contextObjectsDidSave(_notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.fetchData()
        }
    }
}

//
//  DisciplinesViewModel.swift
//  UNES
//
//  Created by João Santos Sena on 17/07/23.
//

import Foundation
import CoreData

class DisciplinesViewModel {
    @Published private(set) var disciplinesMapped = [DisciplineHelperData]()
    
    func fetchData() {
        let context = UNESPersistenceController.shared.container.viewContext
        let semesters = try? context.fetch(SemesterEntity.fetchRequest())
        let classes = try? context.fetch(ClassEntity.fetchRequest())
        
        disciplinesMapped = DisciplineListSupport.transformClassesIntoUiElements(semesters: semesters ?? [], classes: classes ?? [])
    }
}

//
//  ScheduleViewModel.swift
//  UNES
//
//  Created by João Santos Sena on 16/07/23.
//

import Foundation

class ScheduleViewModel {
    @Published private(set) var locations = [ClassLocationEntity]()
    @Published private(set) var schedule = [Int16: [ProcessedClassLocation]]()
    @Published private(set) var built = [ProcessedClassLocation]()
    
    func fetchSchedule() {
        let context = UNESPersistenceController.shared.container.viewContext
        guard let locations = try? context.fetch(ClassLocationEntity.fetchRequest()) else { return }
        self.locations = locations
        
        schedule = ScheduleBlockSupport.createMap(locations)
        built = ScheduleBlockSupport.buildDisplayList(schedule)
    }
}

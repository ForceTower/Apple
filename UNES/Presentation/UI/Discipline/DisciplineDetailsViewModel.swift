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
    
    func fetchData() {
        
    }
}

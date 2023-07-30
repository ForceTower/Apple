//
//  LectureProcessor.swift
//  UNES
//
//  Created by João Santos Sena on 29/07/23.
//

import Foundation
import Arcadia
import CoreData

class LectureProcessor {
    static func process(
        groupId: Int64,
        lectures: [Lecture],
        withContext context: NSManagedObjectContext
    ) throws {
        let cRequest = ClassGroupEntity.fetchRequest()
        cRequest.predicate = NSPredicate(format: "id = %ld", groupId)
        cRequest.fetchLimit = 1
        
        guard let group = try? context.fetch(cRequest).first else {
            print("Failed to find related class group...")
            return
        }
        
        try lectures.forEach { lecture in
            let request = ClassItemEntity.fetchRequest()
            request.predicate = NSPredicate(format: "groupId = %ld AND number = %ld", groupId, Int32(lecture.ordinal))
            request.fetchLimit = 1
            
            let current = try context.fetch(request).first ?? ClassItemEntity(context: context)
            current.number = Int32(lecture.ordinal)
            current.groupId = groupId
            if let date = lecture.date {
                current.date = try? Date(date, strategy: .iso8601)
            }
            current.situation = Int16(lecture.situation)
            current.numberOfMaterials = Int32(lecture.materials.count)
            current.materialLinks = ""
            
            
            try lecture.materials.forEach { material in
                let mRequest = ClassMaterialEntity.fetchRequest()
                mRequest.predicate = NSPredicate(format: "groupId = %ld AND name = %@ AND link = %@", groupId, material.description, material.url)
                mRequest.fetchLimit = 1
                
                let mat = try context.fetch(mRequest).first ?? ClassMaterialEntity(context: context)
                mat.name = material.description
                mat.groupId = groupId
                mat.link = material.url
                mat.group = group
                mat.classItem = current
            }
        }
    }
}

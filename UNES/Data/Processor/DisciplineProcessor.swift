//
//  DisciplineProcessor.swift
//  UNES
//
//  Created by João Santos Sena on 15/07/23.
//

import Foundation
import CoreData
import Arcadia

fileprivate struct LocalClassLocation {
    let group: ClassGroupEntity
    let campus: String?
    let modulo: String?
    let room: String?
    let day: String
    let dayInt: Int
    let startAt: String
    let endAt: String
    let startAtInt: Int
    let endsAtInt: Int
}

class DisciplineProcessor {
    static func process(disciplines: [DisciplineData], atSemester semesterId: Int64, notifying notify: Bool, withContext context: NSManagedObjectContext) throws {
        let allSemesters = try context.fetch(SemesterEntity.fetchRequest())
        
        var currentSemester: SemesterEntity?
        if allSemesters.allSatisfy({ entity in entity.start != nil }) {
            currentSemester = allSemesters.max { first, second in
                first.start! < second.start!
            }
        } else {
            currentSemester = allSemesters.max(by: { first, second in
                first.id < second.id
            })
        }
        
        var allocations = [LocalClassLocation]()
        
        try disciplines.forEach { it in
            let discipline = DisciplineEntity(context: context)
            discipline.id = Int64(it.id)
            discipline.name = it.name.trimmingCharacters(in: .whitespaces)
            discipline.code = it.code.trimmingCharacters(in: .whitespaces)
            discipline.department = it.department?.trimmingCharacters(in: .whitespaces)
            discipline.credits = Int16(it.hours)
            discipline.program = it.program?.trimmingCharacters(in: .whitespaces)
            currentSemester?.addToDisciplines(discipline)
            
            let bound = ClassEntity(context: context)
            bound.id = "\(discipline.id)_\(semesterId)"
            bound.disciplineId = discipline.id
            bound.semesterId = semesterId
            bound.scheduleOnly = false
            bound.missedClasses = Int16(it.result?.missedClasses ?? 0)
            if let finalScore = it.result?.mean {
                bound.finalScore = finalScore
            }
            
            discipline.addToClasses(bound)
            currentSemester?.addToClasses(bound)
            
            try it.classes.forEach { clazz in
                if let t = clazz.teacher {
                    let teacher = TeacherEntity(context: context)
                    teacher.id = Int64(t.id)
                    teacher.name = t.name
                    teacher.email = t.email
                    teacher.department = it.department
                }
                
                // Check for tomfoolery around saving classes with a single group (probably from the html era)
                let group = ClassGroupEntity(context: context)
                group.id = Int64(clazz.id)
                group.classId = bound.id
                group.draft = false
                group.credits = Int16(clazz.hours)
                group.group = clazz.groupName.trimmingCharacters(in: .whitespaces)
                group.teacher = clazz.teacher?.name.trimmingCharacters(in: .whitespaces).localizedCapitalized
                if let teacherId = clazz.teacher?.id {
                    group.teacherId = Int64(teacherId)
                }
                group.teacherEmail = clazz.teacher?.email
                group.clazz = bound
                
                if currentSemester?.id == semesterId {
                    clazz.allocations.forEach { alloc in
                        if let time = alloc.time {
                            allocations.append(
                                LocalClassLocation(
                                    group: group,
                                    campus: alloc.space?.campus,
                                    modulo: alloc.space?.modulo,
                                    room: alloc.space?.location,
                                    day: weekDayOf(time.day + 1),
                                    dayInt: time.day + 1,
                                    startAt: removeSeconds(time.start),
                                    endAt: removeSeconds(time.end),
                                    startAtInt: createTimeInt(time.start),
                                    endsAtInt: createTimeInt(time.end))
                            )
                        }
                    }
                    // Lecture processing! Pog
                }
                try GradeProcessor.process(evaluations: it.evaluations, forClass: bound, notifying: notify, withContext: context, saveAfterChanges: false)
            }
        }
        
        try expandLocations(allocations, context: context)
        try context.save()
    }
    
    private static func expandLocations(_ locations: [LocalClassLocation], context: NSManagedObjectContext) throws {
        if locations.isEmpty { return }
        let delete = try context.execute(NSBatchDeleteRequest(fetchRequest: ClassLocationEntity.fetchRequest())) as? NSBatchDeleteResult
        
        if let deleteResult = delete?.result as? [NSManagedObjectID] {
            let deletedObjects: [AnyHashable: Any] = [
                NSDeletedObjectsKey: deleteResult
            ]
            NSManagedObjectContext.mergeChanges(
                fromRemoteContextSave: deletedObjects,
                into: [context]
            )
        }
        
        
        let starts = Dictionary(grouping: locations, by: \.startAtInt).mapValues { it in it.first!.startAt }
        let ends = Dictionary(grouping: locations, by: \.endsAtInt).mapValues { it in it.first!.endAt }
        
        var allMapped = starts
        ends.forEach { key, value in allMapped[key] = value }
        let allTimes = allMapped.keys.sorted()
        
        locations.forEach { location in
            var start = location.startAtInt
            var index = allTimes.firstIndex(of: start)! + 1
            var end = allTimes[index]
            
            while location.endsAtInt != end {
                let loc = ClassLocationEntity(context: context)
                loc.groupId = location.group.id
                loc.campus = location.campus
                loc.modulo = location.modulo
                loc.room = location.room
                loc.day = location.day
                loc.dayInt = Int16(location.dayInt)
                loc.startsAt = allMapped[start]!
                loc.startsAtInt = Int16(start)
                loc.endsAt = allMapped[end]
                loc.endsAtInt = Int16(end)
                loc.group = location.group
                
                index += 1
                start = end
                end = allTimes[index]
            }
            
            let loc = ClassLocationEntity(context: context)
            loc.groupId = location.group.id
            loc.campus = location.campus
            loc.modulo = location.modulo
            loc.room = location.room
            loc.day = location.day
            loc.dayInt = Int16(location.dayInt)
            loc.startsAt = allMapped[start]!
            loc.startsAtInt = Int16(start)
            loc.endsAt = allMapped[end]
            loc.endsAtInt = Int16(end)
            loc.group = location.group
            
            print("Expanded locations")
        }
    }
    
    static func weekDayOf(_ value: Int) -> String {
        switch(value) {
        case 1: return "DOM"
        case 2: return "SEG"
        case 3: return "TER"
        case 4: return "QUA"
        case 5: return "QUI"
        case 6: return "SEX"
        case 7: return "SAB"
        default: return "???"
        }
    }
    
    private static func createTimeInt(_ value: String) -> Int {
        let parts = value.split(separator: ":")
        if parts.count >= 2 {
            let hour = Int(parts[0]) ?? 0
            let minute = Int(parts[1]) ?? 0
            return hour * 60 + minute
        }
        
        return 0
    }
    
    private static func removeSeconds(_ value: String) -> String {
        return value.split(separator: ":").prefix(2).joined(separator: ":")
    }
}

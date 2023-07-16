//
//  ScheduleBlockSupport.swift
//  UNES
//
//  Created by João Santos Sena on 16/07/23.
//

import Foundation

protocol ProcessedClassLocation {}

struct EmptySpace: ProcessedClassLocation {}

struct ElementSpace: ProcessedClassLocation {
    let location: ClassLocationEntity
}

struct TimeSpace: ProcessedClassLocation {
    let start: String
    let end: String
    let startInt: Int
    let endInt: Int
}

struct DaySpace: ProcessedClassLocation {
    let day: String
    let dayInt: Int
}

class ScheduleBlockSupport {
    static func createMap(_ locations: [ClassLocationEntity]) -> Dictionary<Int16, [ProcessedClassLocation]> {
        let timers = locations.map { it in
            Timed(start: Int(it.startsAtInt), end: Int(it.endsAtInt), startString: it.startsAt, endString: it.endsAt)
        }.distinct { $0.start }.sorted { $0.start < $1.start }
        print("Timers \(timers)")
        
        var result = Dictionary(grouping: locations, by: \.dayInt)
            .mapValues { values in
                let dayList: [ProcessedClassLocation] = timers.map { timed in
                    if let location = values.first(where: { $0.startsAtInt == timed.start && $0.endsAtInt == timed.end }) {
                        return ElementSpace(location: location)
                    } else {
                        return EmptySpace()
                    }
                }
                return dayList
            }
        
        result[-1] = timers.map { timed in
            TimeSpace(start: timed.startString!, end: timed.endString!, startInt: timed.start, endInt: timed.end)
        }
        
        print("Location result \(result)")
        
        return result
    }
    
    static func buildDisplayList(_ data: [Int16: [ProcessedClassLocation]]) -> ([String: Int], [ProcessedClassLocation]) {
        var disciplineColors = [String: Int]()
        var colorIndex = 0
        var result = [ProcessedClassLocation]()
        
        let referenceList = data[-1] ?? []
        
        result.append(EmptySpace())
        
        let daysHeader = data.keys.sorted { $0 < $1 }.filter { $0 != -1 }.map {
            DaySpace(day: DisciplineProcessor.weekDayOf(Int($0)), dayInt: Int($0))
        }
        result.append(contentsOf: daysHeader)
        
        let referenceMap = data.filter { $0.key != -1 }.sorted { $0.key < $1.key }
        for (index, element) in referenceList.enumerated() {
            result.append(element)
            referenceMap.forEach { (_, value) in
                let location = value[index]
                result.append(location)
                if let location = location as? ElementSpace,
                   let code = location.location.group?.clazz?.discipline?.code {
                    if disciplineColors[code] == nil {
                        print("Setup color for \(code)")
                        disciplineColors[code] = colorIndex
                        colorIndex += 1
                    }
                }
            }
        }
        
        return (disciplineColors, result)
    }
}

struct Timed {
    let start: Int
    let end: Int
    let startString: String?
    let endString: String?
}

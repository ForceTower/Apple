//
//  NotificationManager.swift
//  UNES
//
//  Created by João Santos Sena on 18/07/23.
//

import Foundation
import UserNotifications
import FirebaseCrashlytics

class NotificationManager {
    static let shared = NotificationManager()
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, err in
            if let err = err {
                Crashlytics.crashlytics().log("Failed to request notification authorization")
                Crashlytics.crashlytics().record(error: err)
            }
        }
    }
    
    func createNotification(forMessage message: MessageEntity) {
        var title = "Nova mensagem!"
        if message.senderProfile == 3 {
            title = "UEFS"
        } else if let discipline = message.discipline {
            title = discipline
        } else if let sender = message.senderName {
            title = sender
        }
        
        guard let body = message.content else { return }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "Message_\(message.id)",
            content: content,
            trigger: nil)
        
        UNUserNotificationCenter.current().add(request)
        
        message.notified = true
    }
    
    func createNotification(forGrade grade: GradeEntity) {
        if grade.notified == 0 { return }
        var title = "Notas!"
        var body = "Houveram mudanças nas notas"
        
        switch(grade.notified) {
        case 1:
            title = "Avaliação criada"
            body = "A \(grade.name ?? "??") da disciplina \(grade.clazz?.discipline?.name ?? "??") foi criada mas não há notas associadas"
        case 2:
            title = "Data de avaliação modificada"
            body = "A data da avaliação \(grade.name ?? "??") da disciplina \(grade.clazz?.discipline?.name ?? "??") foi alterada"
        case 3:
            title = "Nota postada"
            body = "A nota da \(grade.name ?? "??") da disciplina \(grade.clazz?.discipline?.name ?? "??") está disponível"
        case 4:
            title = "Nota alterada"
            body = "A nota da \(grade.name ?? "??") da disciplina \(grade.clazz?.discipline?.name ?? "??") foi alterada"
        default:
            print("nothing")
            return
        }
        
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "grade_\(grade.objectID)",
            content: content,
            trigger: nil)
        
        UNUserNotificationCenter.current().add(request)
        
        grade.notified = 0
    }
}

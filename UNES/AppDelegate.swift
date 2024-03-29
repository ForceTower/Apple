//
//  AppDelegate.swift
//  UNES
//
//  Created by João Santos Sena on 08/07/23.
//

import UIKit
import CoreData
import Firebase
import FirebaseAnalytics
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
#if DEBUG
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(false)
#endif
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "dev.forcetower.unes.apprefresh", using: nil) { task in
            self.handleAppRefresh(task as! BGAppRefreshTask)
        }
        
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        application.registerForRemoteNotifications()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        scheduleAppRefresh()
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "dev.forcetower.unes.apprefresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
        do {
            try BGTaskScheduler.shared.submit(request)
            print("Scheduled task")
        } catch(let error) {
            print("Scheduling error \(error)")
            Crashlytics.crashlytics().log("Failed to schedule app refresh")
            Crashlytics.crashlytics().record(error: error)
        }
    }
    
    private func handleAppRefresh(_ task: BGAppRefreshTask) {
        Analytics.logEvent("app_background_fetch", parameters: nil)
        var fetchTask: Task<Void, Never>? = nil
        
        let context = UNESPersistenceController.shared.container.newBackgroundContext()
        let (username, password) = context.performAndWait {
            let access = try? context.fetch(AccessEntity.fetchRequest()).first
            return (access?.username, access?.password)
        }
        guard let username = username, let password = password else {
            Analytics.logEvent("app_background_fetch_complete", parameters: nil)
            return
        }
        
        scheduleAppRefresh()
        fetchTask = Task {
            UserDefaults.standard.set(Date(), forKey: "last_sync")
            let result = await PortalDataSync().update(username: username, password: password)
            Analytics.logEvent("app_background_fetch_complete", parameters: nil)
            task.setTaskCompleted(success: result)
        }
        
        task.expirationHandler = {
            Analytics.logEvent("app_background_fetch_canceled", parameters: nil)
            fetchTask?.cancel()
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcmToken = fcmToken {
            print("Received fcm token: \(fcmToken)")
        }
    }
}

//
//  MainCoordinator.swift
//  UNES
//
//  Created by João Santos Sena on 08/07/23.
//

import UIKit
import CoreData

class MainCoordinator : Coordinator {
    private let container: AppDIContainer
    private let window: UIWindow
    
    init(container: AppDIContainer, window: UIWindow) {
        self.container = container
        self.window = window
    }
    
    func start() {
        let request = AccessEntity.fetchRequest()
        request.fetchLimit = 1
        let item = try? UNESPersistenceController.shared.container.viewContext.fetch(request).first
        if item == nil {
            print("Not connected")
            AuthCoordinator(container: container, window: window, coordinator: self).start()
        } else {
            print("Already connected. Moving home")
            HomeCoordinator(container: container, window: window, coordinator: self).start()
        }
    }
    
    func navigateToHome() {
        HomeCoordinator(container: container, window: window, coordinator: self).start()
    }
}

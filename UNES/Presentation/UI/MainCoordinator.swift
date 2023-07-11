//
//  MainCoordinator.swift
//  UNES
//
//  Created by João Santos Sena on 08/07/23.
//

import UIKit

class MainCoordinator : Coordinator {
    private let container: AppDIContainer
    private let window: UIWindow
    
    init(container: AppDIContainer, window: UIWindow) {
        self.container = container
        self.window = window
    }
    
    func start() {
        // TODO: Check if connected
        AuthCoordinator(container: container, window: window).start()
    }
}

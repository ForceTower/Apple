//
//  WelcomeAppViewModel.swift
//  UNES
//
//  Created by João Santos Sena on 08/07/23.
//

class WelcomeAppViewModel {
    private let coordinator: AuthCoordinator
    
    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
    }
    
    func navigateToLoginForm() {
        coordinator.navigateToLoginFlow()
    }
}

//
//  LoginViewModel.swift
//  UNES
//
//  Created by João Santos Sena on 09/07/23.
//

import Foundation

class LoginViewModel {
    private let coordinator: AuthCoordinator
    
    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
    }
    
    func onLogin(username: String, password: String, delegate: LoginResultDelegate) {
        coordinator.navigateToLoggingIn(username: username, password: password, delegate: delegate)
    }
}

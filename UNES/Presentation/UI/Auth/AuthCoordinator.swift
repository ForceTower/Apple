//
//  AuthCoordinator.swift
//  UNES
//
//  Created by João Santos Sena on 09/07/23.
//

import Foundation
import UIKit

class AuthCoordinator : Coordinator {
    private let container: AppDIContainer
    private let window: UIWindow
    private let coordinator: MainCoordinator
    
    private var navigation: UINavigationController? = nil
    
    init(container: AppDIContainer, window: UIWindow, coordinator: MainCoordinator) {
        self.container = container
        self.window = window
        self.coordinator = coordinator
    }
    
    func start() {
        let vc = WelcomeAppViewController(vm: WelcomeAppViewModel(coordinator: self))
        navigation = UINavigationController(rootViewController: vc)
        window.rootViewController = navigation
        window.makeKeyAndVisible()
    }
    
    func navigateToLoginFlow() {
        let vc = LoginViewController(vm: LoginViewModel(coordinator: self))
        navigation?.pushViewController(vc, animated: true)
    }
    
    func navigateToLoggingIn(username: String, password: String, delegate: LoginResultDelegate) {
        let vc = LoggingInViewController(vm: LoggingInViewModel(username: username, password: password, coordinator: self, loginUseCase: LoginUseCase()))
        vc.loginResultDelegate = delegate
        navigation?.pushViewController(vc, animated: true)
    }
    
    func navigateToSignedIn() {
        coordinator.navigateToHome()
    }
}

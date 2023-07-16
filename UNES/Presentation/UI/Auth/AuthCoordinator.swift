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
    
    private var navigation: UINavigationController? = nil
    
    init(container: AppDIContainer, window: UIWindow) {
        self.container = container
        self.window = window
    }
    
    func start() {
        let vc = WelcomeAppViewController(vm: WelcomeAppViewModel(coordinator: self))
        navigation = UINavigationController(rootViewController: vc)
//        let vc = LoginViewController(vm: LoginViewModel(coordinator: self))
        window.rootViewController = navigation
        window.makeKeyAndVisible()
    }
    
    func navigateToLoginFlow() {
        let vc = LoginViewController(vm: LoginViewModel(coordinator: self))
        navigation?.pushViewController(vc, animated: true)
//        window.rootViewController = navigation
//        UIView.transition(with: window,
//                          duration: 0.3,
//                          options: .transitionCrossDissolve,
//                          animations: nil,
//                          completion: nil)
    }
    
    func navigateToLoggingIn(username: String, password: String) {
        let vc = LoggingInViewController(vm: LoggingInViewModel(username: username, password: password, loginUseCase: LoginUseCase()))
        navigation?.pushViewController(vc, animated: true)
    }
}

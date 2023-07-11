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
    
    init(container: AppDIContainer, window: UIWindow) {
        self.container = container
        self.window = window
    }
    
    func start() {
        let vc = WelcomeAppViewController(vm: WelcomeAppViewModel(coordinator: self))
//        let vc = LoginViewController(vm: LoginViewModel(coordinator: self))
        window.rootViewController = vc
        window.makeKeyAndVisible()
    }
    
    func navigateToLoginFlow() {
        let vc = LoginViewController(vm: LoginViewModel(coordinator: self))
        let navigation = UINavigationController(rootViewController: vc)
        window.rootViewController = navigation
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }
}

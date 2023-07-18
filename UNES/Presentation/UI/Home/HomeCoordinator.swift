//
//  HomeCoordinator.swift
//  UNES
//
//  Created by João Santos Sena on 15/07/23.
//

import Foundation

import UIKit

class HomeCoordinator : Coordinator {
    private let container: AppDIContainer
    private let window: UIWindow
    private let coordinator: MainCoordinator
    
    init(container: AppDIContainer, window: UIWindow, coordinator: MainCoordinator) {
        self.container = container
        self.window = window
        self.coordinator = coordinator
    }
    
    func start() {
        let tabBar = UITabBarController()
        
//        let dashboard = DashboardViewController()
//        dashboard.tabBarItem = UITabBarItem(title: "Início", image: .init(systemName: "doc.richtext"), tag: 0)
        
        let schedule = UINavigationController(rootViewController: ScheduleViewController(vm: ScheduleViewModel()))
        schedule.tabBarItem = UITabBarItem(title: "Horários", image: .init(systemName: "clock"), tag: 1)
        
        let messages = UINavigationController(rootViewController: MessagesViewControler(vm: MessagesViewModel()))
        messages.tabBarItem = UITabBarItem(title: "Mensagens", image: .init(systemName: "envelope"), tag: 2)
        
        
        let disciplines = UINavigationController(rootViewController: DisciplinesViewController(vm: DisciplinesViewModel()))
        disciplines.tabBarItem = UITabBarItem(title: "Disciplinas", image: .init(systemName: "book"), tag: 3)
        // list.bullet for more
        
        tabBar.setViewControllers([schedule, messages, disciplines], animated: true)
        
        window.rootViewController = tabBar
        window.makeKeyAndVisible()
    }
}

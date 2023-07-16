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
    
    init(container: AppDIContainer, window: UIWindow) {
        self.container = container
        self.window = window
    }
    
    func start() {
        let tabBar = UITabBarController()
        
        let dashboard = DashboardViewController()
        dashboard.tabBarItem = UITabBarItem(title: "Início", image: .init(systemName: "doc.richtext"), tag: 0)
        
        let schedule = ScheduleViewController()
        schedule.tabBarItem = UITabBarItem(title: "Horários", image: .init(systemName: "clock"), tag: 1)
        
        let messages = UINavigationController(rootViewController: MessagesViewControler(vm: MessagesViewModel()))
        messages.tabBarItem = UITabBarItem(title: "Mensagens", image: .init(systemName: "envelope"), tag: 2)
        
        
        let disciplines = UINavigationController(rootViewController: GradesViewController())
        disciplines.tabBarItem = UITabBarItem(title: "Disciplinas", image: .init(systemName: "book"), tag: 3)
        // list.bullet for more
        
        tabBar.setViewControllers([dashboard, schedule, messages, disciplines], animated: true)
        
        window.rootViewController = tabBar
        window.makeKeyAndVisible()
    }
}

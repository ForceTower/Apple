//
//  Coordinator.swift
//  UNES
//
//  Created by João Santos Sena on 08/07/23.
//

import UIKit

protocol Coordinator {
    func start()
}

protocol NavigationCoordinator: Coordinator {
    var navigationController: UINavigationController { get }
}

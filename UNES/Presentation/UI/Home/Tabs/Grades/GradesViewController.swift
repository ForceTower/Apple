//
//  GradesViewController.swift
//  UNES
//
//  Created by João Santos Sena on 15/07/23.
//

import UIKit

class GradesViewController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.text = "Welcome to Schedule"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
        ])
    }
}

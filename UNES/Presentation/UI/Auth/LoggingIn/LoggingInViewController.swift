//
//  LoggingInViewController.swift
//  UNES
//
//  Created by João Santos Sena on 11/07/23.
//

import Foundation
import UIKit
import Combine

class LoggingInViewController : UIViewController {
    private let vm: LoggingInViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    private let labelName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(vm: LoggingInViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        vm.start()
        configureView()
        bindObservables()
    }
    
    private func configureView() {
        navigationItem.hidesBackButton = true
        
        view.addSubview(labelName)
        view.backgroundColor = .systemBlue
        
        NSLayoutConstraint.activate([
            labelName.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            labelName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            labelName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24)
        ])
    }
    
    private func bindObservables() {
        vm.onLoginProgress.sink { [weak self] completion in
            switch (completion) {
            case .failure(let error):
                self?.handleError(error: error)
            case .finished:
                self?.onLoginCompleted()
            }
        } receiveValue: { progress in
            print("Progress value received: \(progress)")
        }.store(in: &subscriptions)
        
        vm.$name.sink { [weak self] name in
            if let name = name {
                self?.labelName.text = "Olá \(name)"
            }
        }.store(in: &subscriptions)
    }
    
    private func onLoginCompleted() {
        vm.onLoginCompleted()
        print("Login completed!")
    }
    
    private func handleError(error: PortalAuthError) {
        print("Something wrong happened. Error: \(error)")
        navigationController?.popViewController(animated: true)
    }
}

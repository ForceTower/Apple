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
    var loginResultDelegate: LoginResultDelegate? = nil
    
    private let labelName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let labelStatus: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .thin)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loading: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
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
        initView()
        setupConstraints()
        bindObservables()
    }
    
    private func initView() {
        navigationItem.hidesBackButton = true
        
        view.addSubview(labelName)
        view.addSubview(loading)
        view.addSubview(labelStatus)
        
        loading.startAnimating()
        
        view.backgroundColor = .systemBackground
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            labelName.topAnchor.constraint(equalTo: loading.bottomAnchor, constant: 16),
            labelName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            labelName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            
            labelStatus.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 16),
            labelStatus.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            labelStatus.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
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
        } receiveValue: { [weak self] progress in
            print("Progress value received: \(progress)")
            self?.handleProgress(progress)
        }.store(in: &subscriptions)
        
        vm.$name.sink { [weak self] name in
            if let name = name {
                self?.labelName.text = "Olá \(name)"
            }
        }.store(in: &subscriptions)
    }
    
    private func handleProgress(_ progress: PortalAuthProgress) {
        switch progress {
        case .handshake:
            labelStatus.text = "Conectando"
        case .fetchedUser(_):
            labelStatus.text = "Buscando informacoes"
        case .fetchedMessages:
            labelStatus.text = "Recebendo mensagens"
        case .fetchedSemesterInfo:
            labelStatus.text = "Encontrando informacoes dos semestres"
        case .fetchedGrades:
            labelStatus.text = "Finalizando..."
        }
    }
    
    private func onLoginCompleted() {
        vm.onLoginCompleted()
        print("Login completed!")
    }
    
    private func handleError(error: PortalAuthError) {
        print("Something wrong happened. Error: \(error)")
        navigationController?.popViewController(animated: true)
        loginResultDelegate?.didFailToLogin(withError: error)
    }
}

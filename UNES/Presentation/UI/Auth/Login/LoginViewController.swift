//
//  LoginViewController.swift
//  UNES
//
//  Created by João Santos Sena on 08/07/23.
//

import UIKit

class LoginViewController : UIViewController {
    private let vm: LoginViewModel
    private let inputUsername: UITextField = {
        let input = UITextField()
        input.borderStyle = .roundedRect
        input.placeholder = "Usuário"
        input.autocapitalizationType = .none
        input.autocorrectionType = .no
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private let inputPassword: UITextField = {
        let input = UITextField()
        input.borderStyle = .roundedRect
        input.placeholder = "Senha"
        input.autocapitalizationType = .none
        input.autocorrectionType = .no
        input.isSecureTextEntry = true
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    init(vm: LoginViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        let background = UIImage(named: "new_login")
        let imageBg = UIImageView(image: background)
        imageBg.contentMode = .scaleAspectFill
        imageBg.translatesAutoresizingMaskIntoConstraints = false
        
        
        let btnAbout = UIButton()
        btnAbout.configuration = .plain()
        btnAbout.configuration?.title = "Sobre o UNES"
        btnAbout.tintColor = .systemBlue
        btnAbout.translatesAutoresizingMaskIntoConstraints = false
        
        
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 8
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.3
        card.layer.shadowOffset = .zero
        card.layer.shadowRadius = 2
        card.translatesAutoresizingMaskIntoConstraints = false
        
        let labelInfo = UILabel()
        labelInfo.text = "Entre usando a sua conta do Portal"
        labelInfo.font = .systemFont(ofSize: 14, weight: .medium)
        labelInfo.numberOfLines = 0
        labelInfo.textAlignment = .left
        labelInfo.translatesAutoresizingMaskIntoConstraints = false
        
        let btnLogin = UIButton()
        btnLogin.configuration = .filled()
        btnLogin.configuration?.title = "Entrar"
        btnLogin.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageBg)
        view.addSubview(btnAbout)
        view.addSubview(card)
        card.addSubview(labelInfo)
        card.addSubview(inputUsername)
        card.addSubview(inputPassword)
        card.addSubview(btnLogin)
        
        NSLayoutConstraint.activate([
            imageBg.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageBg.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageBg.topAnchor.constraint(equalTo: view.topAnchor),
            imageBg.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            btnAbout.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -4),
            btnAbout.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnAbout.widthAnchor.constraint(equalToConstant: 180)
        ])
        
        NSLayoutConstraint.activate([
            card.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            card.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            card.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        NSLayoutConstraint.activate([
            labelInfo.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            labelInfo.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            labelInfo.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
        ])

        NSLayoutConstraint.activate([
            inputUsername.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            inputUsername.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            inputUsername.topAnchor.constraint(equalTo: labelInfo.bottomAnchor, constant: 8),
            inputUsername.heightAnchor.constraint(equalToConstant: 36)
        ])

        NSLayoutConstraint.activate([
            inputPassword.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            inputPassword.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            inputPassword.topAnchor.constraint(equalTo: inputUsername.bottomAnchor, constant: 4),
        ])

        NSLayoutConstraint.activate([
            btnLogin.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            btnLogin.topAnchor.constraint(equalTo: inputPassword.bottomAnchor, constant: 16),
            btnLogin.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16)
        ])
        
        view.backgroundColor = .systemBackground
    }
    
    @objc func onLogin() {
        guard let username = inputUsername.text else { return }
        guard let password = inputPassword.text else { return }
        
        print("Username [\(username)] >< Password [\(password)]")
    }
}

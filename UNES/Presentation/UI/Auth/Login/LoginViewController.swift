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
        input.borderStyle = .none
        input.setLeftPaddingPoints(10)
        input.setRightPaddingPoints(10)
        input.placeholder = "Usuário"
        input.autocapitalizationType = .none
        input.autocorrectionType = .no
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private let inputPassword: UITextField = {
        let input = UITextField()
        input.borderStyle = .none
        input.setLeftPaddingPoints(10)
        input.setRightPaddingPoints(10)
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
        let imageLogo = UIImageView(image: UIImage(named: "ColoredLogo"))
        imageLogo.contentMode = UIImageView.ContentMode.scaleAspectFit
        imageLogo.clipsToBounds = true
        imageLogo.translatesAutoresizingMaskIntoConstraints = false
        
//        let btnAbout = UIButton()
//        btnAbout.configuration = .plain()
//        btnAbout.configuration?.title = "Sobre o UNES"
//        btnAbout.tintColor = .systemBlue
//        btnAbout.translatesAutoresizingMaskIntoConstraints = false
        
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
        btnLogin.addTarget(self, action: #selector(onLogin), for: .touchUpInside)
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let loginForm = UIView()
        loginForm.layer.borderWidth = 1
        loginForm.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        loginForm.layer.cornerRadius = 8
        loginForm.translatesAutoresizingMaskIntoConstraints = false
        
        let hairlineForm = UIView()
        hairlineForm.backgroundColor = .lightGray.withAlphaComponent(0.5)
        hairlineForm.translatesAutoresizingMaskIntoConstraints = false
        
        
//        view.addSubview(btnAbout)
        view.addSubview(stack)
        stack.addArrangedSubview(imageLogo)
        stack.addArrangedSubview(labelInfo)
        stack.addArrangedSubview(loginForm)
        stack.addArrangedSubview(btnLogin)
        
        stack.setCustomSpacing(16, after: imageLogo)
        stack.setCustomSpacing(8, after: labelInfo)
        stack.setCustomSpacing(16, after: loginForm)
        
        loginForm.addSubview(inputUsername)
        loginForm.addSubview(hairlineForm)
        loginForm.addSubview(inputPassword)
        
        NSLayoutConstraint.activate([
            imageLogo.heightAnchor.constraint(equalToConstant: 200)
        ])
        
//        NSLayoutConstraint.activate([
//            btnAbout.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -4),
//            btnAbout.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            btnAbout.widthAnchor.constraint(equalToConstant: 180)
//        ])
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -36),
        ])
//
        NSLayoutConstraint.activate([
            inputUsername.leadingAnchor.constraint(equalTo: loginForm.leadingAnchor),
            inputUsername.trailingAnchor.constraint(equalTo: loginForm.trailingAnchor),
            inputUsername.topAnchor.constraint(equalTo: loginForm.topAnchor),
            inputUsername.heightAnchor.constraint(equalToConstant: 40),
            
            hairlineForm.topAnchor.constraint(equalTo: inputUsername.bottomAnchor),
            hairlineForm.leadingAnchor.constraint(equalTo: loginForm.leadingAnchor),
            hairlineForm.trailingAnchor.constraint(equalTo: loginForm.trailingAnchor),
            hairlineForm.heightAnchor.constraint(equalToConstant: 1),
            
            inputPassword.leadingAnchor.constraint(equalTo: loginForm.leadingAnchor),
            inputPassword.trailingAnchor.constraint(equalTo: loginForm.trailingAnchor),
            inputPassword.topAnchor.constraint(equalTo: hairlineForm.bottomAnchor),
            inputPassword.bottomAnchor.constraint(equalTo: loginForm.bottomAnchor),
            inputPassword.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        view.backgroundColor = .systemBackground
    }
    
    @objc func onLogin() {
        guard let username = inputUsername.text else { return }
        guard let password = inputPassword.text else { return }
        vm.onLogin(username: username, password: password)
    }
}

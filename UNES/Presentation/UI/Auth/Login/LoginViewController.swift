//
//  LoginViewController.swift
//  UNES
//
//  Created by João Santos Sena on 08/07/23.
//

import UIKit

class LoginViewController : UIViewController {
    private let vm: LoginViewModel
    
    private lazy var inputUsername: UITextField = {
        let input = UITextField()
        input.borderStyle = .none
        input.setLeftPaddingPoints(10)
        input.setRightPaddingPoints(10)
        input.placeholder = "Usuário"
        input.autocapitalizationType = .none
        input.autocorrectionType = .no
//        input.delegate = self
        input.returnKeyType = .next
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private lazy var inputPassword: UITextField = {
        let input = UITextField()
        input.borderStyle = .none
        input.setLeftPaddingPoints(10)
        input.setRightPaddingPoints(10)
        input.placeholder = "Senha"
        input.autocapitalizationType = .none
        input.autocorrectionType = .no
        input.isSecureTextEntry = true
        input.returnKeyType = .done
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    private let btnLogin: UIButton = {
        let btn = UIButton()
        btn.configuration = .filled()
        btn.configuration?.title = "Entrar"
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let scrollViewContent: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        labelInfo.textAlignment = .center
        labelInfo.translatesAutoresizingMaskIntoConstraints = false
        
        btnLogin.addTarget(self, action: #selector(onLogin), for: .touchUpInside)
//        btnAbout.addTarget(self, action: #selector(onTapAbout), for: .touchUpInside)
        inputUsername.addTarget(self, action: #selector(onNextUsername), for: .primaryActionTriggered)
        inputPassword.addTarget(self, action: #selector(onLogin), for: .primaryActionTriggered)
        
        let loginForm = UIView()
        loginForm.layer.borderWidth = 1
        loginForm.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        loginForm.layer.cornerRadius = 8
        loginForm.translatesAutoresizingMaskIntoConstraints = false
        
        let hairlineForm = UIView()
        hairlineForm.backgroundColor = .lightGray.withAlphaComponent(0.5)
        hairlineForm.translatesAutoresizingMaskIntoConstraints = false
        
//        view.addSubview(btnAbout)
        view.addSubview(scrollView)
        
        scrollView.addSubview(scrollViewContent)
        scrollViewContent.addSubview(stack)
        
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
            imageLogo.heightAnchor.constraint(equalToConstant: 200),

//            btnAbout.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -4),
//            btnAbout.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            btnAbout.widthAnchor.constraint(equalToConstant: 180),
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            scrollViewContent.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            scrollViewContent.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            scrollViewContent.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            scrollViewContent.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            scrollViewContent.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            scrollViewContent.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor),

            stack.leadingAnchor.constraint(equalTo: scrollViewContent.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: scrollViewContent.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            stack.centerYAnchor.constraint(equalTo: scrollViewContent.safeAreaLayoutGuide.centerYAnchor, constant: -36),

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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)

        view.backgroundColor = .systemBackground
    }
    
    @objc func onLogin() {
        guard let username = inputUsername.text else { return }
        guard let password = inputPassword.text else { return }
        inputUsername.resignFirstResponder()
        inputPassword.resignFirstResponder()
        vm.onLogin(username: username, password: password, delegate: self)
    }
    
    @objc func onNextUsername() {
        inputPassword.becomeFirstResponder()
    }
    
    @objc func onTapAbout() {
        if let url = URL(string: "https://github.com/ForceTower/Apple") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification) {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
}

extension LoginViewController: LoginResultDelegate {
    func didFailToLogin(withError error: PortalAuthError) {
        var message = "Erro desconhecido ao fazer login. Me envie um email sobre isso em joaopaulo761@gmail.com"
        switch error {
        case .invalidCredentials:
            message = "Usuário ou senha estão incorretos"
        case .otherError(let underlyingError):
            message = "Erro ao entrar. Causa \(underlyingError.localizedDescription). Me envie um email sobre isso em joaopaulo761@gmail.com"
        }
        
        let alert = UIAlertController(
            title: "Erro ao fazer login",
            message: message,
            preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}

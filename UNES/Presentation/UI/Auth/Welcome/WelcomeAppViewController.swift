//
//  WelcomeAppViewController.swift
//  UNES
//
//  Created by João Santos Sena on 08/07/23.
//

import Foundation
import UIKit

class WelcomeAppViewController : UIViewController {
    private let vm: WelcomeAppViewModel
    
    init(vm: WelcomeAppViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        let imageWelcome = UIImage(named: "classroom_working")
        let imageViewWelcome = UIImageView(image: imageWelcome)
        imageViewWelcome.contentMode = .scaleAspectFit
        imageViewWelcome.translatesAutoresizingMaskIntoConstraints = false
        
        let labelWelcomeTitle = UILabel()
        labelWelcomeTitle.text = "Boas-vindas ao UNES"
        labelWelcomeTitle.font = .systemFont(ofSize: 21, weight: .medium)
        labelWelcomeTitle.numberOfLines = 0
        labelWelcomeTitle.textAlignment = .center
        labelWelcomeTitle.translatesAutoresizingMaskIntoConstraints = false
        
        let labelWelcomeCaption = UILabel()
        labelWelcomeCaption.text = "A maneira mais fácil de acessar o Sagres"
        labelWelcomeCaption.font = .systemFont(ofSize: 15)
        labelWelcomeCaption.textColor = .darkGray
        labelWelcomeCaption.numberOfLines = 0
        labelWelcomeCaption.textAlignment = .center
        labelWelcomeCaption.translatesAutoresizingMaskIntoConstraints = false
        
        let labelPrivacy = UILabel()
        labelPrivacy.text = "Ao continuar, você concorda com os\nTermos de Uso e Política de Privacidade"
        labelPrivacy.font = .systemFont(ofSize: 13)
        labelPrivacy.textColor = .darkGray
        labelPrivacy.numberOfLines = 0
        labelPrivacy.textAlignment = .center
        labelPrivacy.translatesAutoresizingMaskIntoConstraints = false
        
        let btnGetStarted = UIButton()
        btnGetStarted.configuration = .filled()
        btnGetStarted.configuration?.title = "Primeiros passos"
        btnGetStarted.configuration?.titleAlignment = .center
        btnGetStarted.addTarget(self, action: #selector(onGetStarted), for: .touchUpInside)
        btnGetStarted.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(imageViewWelcome)
        view.addSubview(labelWelcomeTitle)
        view.addSubview(labelWelcomeCaption)
        view.addSubview(labelPrivacy)
        view.addSubview(btnGetStarted)
        view.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            labelPrivacy.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            labelPrivacy.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            labelPrivacy.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
        ])
        
        NSLayoutConstraint.activate([
            btnGetStarted.bottomAnchor.constraint(equalTo: labelPrivacy.topAnchor, constant: -24),
            btnGetStarted.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnGetStarted.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            labelWelcomeCaption.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            labelWelcomeCaption.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            labelWelcomeCaption.bottomAnchor.constraint(equalTo: btnGetStarted.topAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            labelWelcomeTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            labelWelcomeTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            labelWelcomeTitle.bottomAnchor.constraint(equalTo: labelWelcomeCaption.topAnchor, constant: -4),
        ])
        
        NSLayoutConstraint.activate([
            imageViewWelcome.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            imageViewWelcome.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            imageViewWelcome.bottomAnchor.constraint(equalTo: labelWelcomeTitle.topAnchor, constant: -16),
            imageViewWelcome.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
        ])
    }
    
    @objc func onGetStarted() {
        vm.navigateToLoginForm()
    }
}

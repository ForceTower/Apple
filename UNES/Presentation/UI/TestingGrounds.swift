//
//  TestingGrounds.swift
//  UNES
//
//  Created by João Santos Sena on 11/07/23.
//

import UIKit

class MiddleView: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "MIDDLE TITLE"
        
        return label
    }()
    
    let paragraphLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
        ])
        
        addSubview(paragraphLabel)
        NSLayoutConstraint.activate([
            paragraphLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            paragraphLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            paragraphLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            paragraphLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ text: String) {
        paragraphLabel.text = text
    }
}

class ViewController: UIViewController {
    let topView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 30)
        label.text = "TOP VIEW"
        
        return label
    }()
    
    let middleView: MiddleView = {
        let view = MiddleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        
        return view
    }()
    
    let bottomView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 30)
        label.text = "BOTTOM VIEW"
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(topView)
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        view.addSubview(middleView)
        NSLayoutConstraint.activate([
            middleView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 24),
            middleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            middleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        view.addSubview(bottomView)
        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: middleView.bottomAnchor, constant: 24),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        middleView.configure("HERE'S A BUNCH OF TEXT WE DON'T KNOW HOW LONG IT WILL BE PROBABLY AN IN DEPTH EXPLANATION OF SOMETHING IMPORTANT WITH POSSIBLE FOOTNOTES*")
        
        view.backgroundColor = .systemBackground
    }
}

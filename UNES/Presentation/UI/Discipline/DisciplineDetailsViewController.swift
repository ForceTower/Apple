//
//  DisciplineDetailsViewController.swift
//  UNES
//
//  Created by João Santos Sena on 20/07/23.
//

import UIKit
import Combine

class DisciplineDetailsViewController: UIViewController, DisciplineDetailsActionsDelegate {
    private let vm: DisciplineDetailsViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(vm: DisciplineDetailsViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var card: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.systemGray.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameLbl: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = .systemFont(ofSize: 18, weight: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let departmentLbl: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = .systemFont(ofSize: 14, weight: .regular)
        view.textColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let missesLeftLbl: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = .systemFont(ofSize: 14, weight: .regular)
        view.textColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let hoursLbl: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = .systemFont(ofSize: 16, weight: .medium)
        view.textColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let clockImg: UIImageView = {
        let image = UIImage(systemName: "clock")
        let view = UIImageView(image: image)
        view.contentMode = .center
        view.tintColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let infoDiv: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let missedClassesLbl: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = .systemFont(ofSize: 16, weight: .regular)
        view.textColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let missedImg: UIImageView = {
        let image = UIImage(systemName: "pencil.and.ruler")
        let view = UIImageView(image: image)
        view.contentMode = .center
        view.tintColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let missedTextLbl: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.text = "faltas"
        view.font = .systemFont(ofSize: 14, weight: .regular)
        view.textColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let helperView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var viewPager: DisciplineDetailsContentView = {
        let view = DisciplineDetailsContentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        vm.updateData()
        vm.fetchData()
        setupViews()
        setupConstraints()
        observe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        vm.setup()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        title = "Detalhes"
        
        view.addSubview(card)
        view.addSubview(viewPager)
        card.addSubview(nameLbl)
        card.addSubview(departmentLbl)
        card.addSubview(missesLeftLbl)
        card.addSubview(hoursLbl)
        card.addSubview(clockImg)
        card.addSubview(infoDiv)
        card.addSubview(stack)
        helperView.addSubview(missedClassesLbl)
        helperView.addSubview(missedImg)
        stack.addArrangedSubview(helperView)
        stack.addArrangedSubview(missedTextLbl)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            card.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            card.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            
            nameLbl.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            nameLbl.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            nameLbl.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            
            departmentLbl.topAnchor.constraint(equalTo: nameLbl.bottomAnchor, constant: 4),
            departmentLbl.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            departmentLbl.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            
            missesLeftLbl.topAnchor.constraint(equalTo: departmentLbl.bottomAnchor, constant: 4),
            missesLeftLbl.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            missesLeftLbl.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            
            infoDiv.topAnchor.constraint(equalTo: missesLeftLbl.bottomAnchor, constant: 8),
            infoDiv.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 80),
            infoDiv.heightAnchor.constraint(equalToConstant: 48),
            infoDiv.widthAnchor.constraint(equalToConstant: 1),
            
            hoursLbl.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            hoursLbl.topAnchor.constraint(equalTo: infoDiv.topAnchor),
            hoursLbl.bottomAnchor.constraint(equalTo: infoDiv.bottomAnchor),
            
            clockImg.leadingAnchor.constraint(equalTo: hoursLbl.trailingAnchor, constant: 4),
            clockImg.topAnchor.constraint(equalTo: infoDiv.topAnchor),
            clockImg.bottomAnchor.constraint(equalTo: infoDiv.bottomAnchor),
            
            stack.leadingAnchor.constraint(equalTo: infoDiv.trailingAnchor, constant: 12),
            stack.topAnchor.constraint(equalTo: infoDiv.topAnchor, constant: 4),
            stack.bottomAnchor.constraint(equalTo: infoDiv.bottomAnchor),
            
            missedClassesLbl.leadingAnchor.constraint(equalTo: helperView.leadingAnchor),
            missedClassesLbl.topAnchor.constraint(equalTo: helperView.topAnchor),
            missedClassesLbl.bottomAnchor.constraint(equalTo: helperView.bottomAnchor),
            
            missedImg.leadingAnchor.constraint(equalTo: missedClassesLbl.trailingAnchor, constant: 4),
            missedClassesLbl.topAnchor.constraint(equalTo: helperView.topAnchor),
            missedClassesLbl.bottomAnchor.constraint(equalTo: helperView.bottomAnchor),
            
            card.bottomAnchor.constraint(equalTo: infoDiv.bottomAnchor, constant: 16),
            
            viewPager.topAnchor.constraint(equalTo: card.bottomAnchor),
            viewPager.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            viewPager.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewPager.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func observe() {
        vm.$clazz
            .sink { [weak self] group in
                self?.setupWithGroup(group)
            }
            .store(in: &cancellables)
    }
    
    private func setupWithGroup(_ group: ClassGroupEntity?) {
        let credits = group?.credits
        let missed = group?.clazz?.missedClasses
        nameLbl.text = group?.clazz?.discipline?.name?.localizedCapitalized
        departmentLbl.text = group?.clazz?.discipline?.department?.localizedCapitalized
        
        if let missed = missed, let credits = credits {
            let left = (credits / 4) - missed
            missesLeftLbl.text = "Ainda restam \(left) faltas"
        } else {
            missesLeftLbl.text = "Nao dá para saber quantas faltas restam..."
        }
        if let credits = credits {
            hoursLbl.text = "\(credits)h"
        }
        if let missed = missed {
            missedClassesLbl.text = "\(missed)"
        }
        viewPager.setup(group)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        vm.onClose()
    }
    
    func onNavigateToMaterials() {
        let vc = DisciplineMaterialsViewController(vm: DisciplineMaterialsViewModel(groupId: vm.classId))
        navigationController?.pushViewController(vc, animated: true)
    }
}

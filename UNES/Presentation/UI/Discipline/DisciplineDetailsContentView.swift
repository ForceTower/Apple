//
//  DisciplineDetailsContentView.swift
//  UNES
//
//  Created by João Santos Sena on 22/07/23.
//

import UIKit

class DisciplineDetailsContentView : UIView {
    var delegate: DisciplineDetailsActionsDelegate? = nil
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let content: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let teacherHeader: UILabel = {
        let view = UILabel()
        view.text = "Professor"
        view.font = .systemFont(ofSize: 14, weight: .regular)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let teacherName: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 15, weight: .medium)
        view.textColor = .systemBlue
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let programView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = .systemBlue.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let disciplineProgramTitle: UILabel = {
        let view = UILabel()
        view.text = "Ementa"
        view.font = .systemFont(ofSize: 14, weight: .regular)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let disciplineProgram: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14, weight: .light)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let materialsBtn: UIButton = {
        let btn = UIButton()
        btn.configuration = .gray()
        btn.configuration?.title = "Ver materiais postados"
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepareView()
    }
    
    func setup(_ group: ClassGroupEntity?) {
        teacherName.text = group?.teacher
        if let program = group?.clazz?.discipline?.program, !program.isEmpty {
            disciplineProgram.text = program
        } else {
            disciplineProgram.text = "Nada foi cadastrado para esta disciplina... :("
        }
    }
    
    private func prepareView() {
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        addSubview(scrollView)
        scrollView.addSubview(content)
        content.addSubview(teacherHeader)
        content.addSubview(teacherName)
        content.addSubview(programView)
        content.addSubview(materialsBtn)
        programView.addSubview(disciplineProgramTitle)
        programView.addSubview(disciplineProgram)
        
        materialsBtn.addTarget(self, action: #selector(onMaterialsBtnClick), for: .touchUpInside)
    }
    
    @objc func onMaterialsBtnClick() {
        delegate?.onNavigateToMaterials()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            content.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            content.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            content.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            content.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            content.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor),
            
            teacherHeader.topAnchor.constraint(equalTo: content.topAnchor, constant: 16),
            teacherHeader.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 16),
            teacherHeader.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -16),
            
            teacherName.topAnchor.constraint(equalTo: teacherHeader.bottomAnchor, constant: 4),
            teacherName.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 16),
            teacherName.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -16),
            
            programView.topAnchor.constraint(equalTo: teacherName.bottomAnchor, constant: 16),
            programView.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 16),
            programView.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -16),
            
            disciplineProgramTitle.topAnchor.constraint(equalTo: programView.topAnchor, constant: 16),
            disciplineProgramTitle.leadingAnchor.constraint(equalTo: programView.leadingAnchor, constant: 16),
            disciplineProgramTitle.trailingAnchor.constraint(equalTo: programView.trailingAnchor, constant: -16),
            
            disciplineProgram.topAnchor.constraint(equalTo: disciplineProgramTitle.bottomAnchor, constant: 4),
            disciplineProgram.bottomAnchor.constraint(equalTo: programView.bottomAnchor, constant: -16),
            disciplineProgram.leadingAnchor.constraint(equalTo: programView.leadingAnchor, constant: 16),
            disciplineProgram.trailingAnchor.constraint(equalTo: programView.trailingAnchor, constant: -16),
            
            materialsBtn.topAnchor.constraint(equalTo: programView.bottomAnchor, constant: 24),
            materialsBtn.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 16),
            materialsBtn.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -16),
        ])
    }
}

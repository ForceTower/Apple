//
//  DisciplineHeaderViewCell.swift
//  UNES
//
//  Created by João Santos Sena on 17/07/23.
//

import UIKit

class DisciplineHeaderViewCell: UICollectionViewCell {
    static let identifier = "DisciplineHeaderViewCell"
    
    private let titleLbl: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 20, weight: .medium)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let codeLbl: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14, weight: .regular)
        view.textColor = .systemCyan
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let departmentLbl: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14, weight: .regular)
        view.textColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepare()
    }
    
    private func prepare() {
        setupView()
        setupConstraints()
    }
    
    func setup(_ item: ClassEntity) {
        if let name = item.discipline?.name {
            titleLbl.text = name.localizedCapitalized
        }
        if let code = item.discipline?.code {
            codeLbl.text = code
        }
        if let dep = item.discipline?.department {
            departmentLbl.text = dep.localizedCapitalized
        }
    }
    
    private func setupView() {
        contentView.addSubview(titleLbl)
        contentView.addSubview(codeLbl)
        contentView.addSubview(departmentLbl)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            codeLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 4),
            codeLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            codeLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            departmentLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 4),
            departmentLbl.leadingAnchor.constraint(equalTo: codeLbl.trailingAnchor, constant: 12),
            departmentLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            departmentLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
}

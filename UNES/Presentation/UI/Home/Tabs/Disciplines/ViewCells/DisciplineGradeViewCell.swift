//
//  DisciplineGradeViewCell.swift
//  UNES
//
//  Created by João Santos Sena on 17/07/23.
//

import UIKit

class DisciplineGradeViewCell: UICollectionViewCell {
    static let identifier = "DisciplineGradeViewCell"
    
    private let titleLbl: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 15, weight: .medium)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dateLbl: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14, weight: .regular)
        view.textColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let valueLbl: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16, weight: .bold)
        view.textAlignment = .right
        view.textColor = .systemCyan
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
    
    func setup(_ item: ClassEntity, grade: GradeEntity) {
        if let name = grade.name {
            titleLbl.text = name
        }
        if let date = grade.date {
            if let parsed = try? Date(date, strategy: .iso8601) {
                dateLbl.text = parsed.formatted(date: .numeric, time: .omitted)
            } else {
                dateLbl.text = date
            }
        } else {
            dateLbl.text = "Não definida"
        }
        if let value = grade.grade {
            valueLbl.text = value
        } else {
            valueLbl.text = "Não divulgada"
        }
    }
    
    private func setupView() {
        contentView.addSubview(titleLbl)
        contentView.addSubview(dateLbl)
        contentView.addSubview(valueLbl)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            valueLbl.topAnchor.constraint(equalTo: titleLbl.topAnchor, constant: 8),
            valueLbl.bottomAnchor.constraint(equalTo: dateLbl.bottomAnchor, constant: -8),
            valueLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            valueLbl.leadingAnchor.constraint(equalTo: titleLbl.trailingAnchor, constant: 4),
            
            dateLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 2),
            dateLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateLbl.trailingAnchor.constraint(equalTo: titleLbl.trailingAnchor),
            dateLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}

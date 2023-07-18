//
//  EmptySemesterViewCell.swift
//  UNES
//
//  Created by João Santos Sena on 17/07/23.
//

import UIKit

class EmptySemesterViewCell: UICollectionViewCell {
    static let identifier = "EmptySemesterViewCell"
    
    private let nameLbl: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 15, weight: .medium)
        view.numberOfLines = 0
        view.textAlignment = .center
        view.text = "As disciplinas deste semestre ainda não foram baixadas.\nIsso tem impacto direto no score calculado."
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
    
    func setup(_ item: SemesterEntity) {
        if let name = item.name {
            if name.count > 4 {
                let index = name.index(name.startIndex, offsetBy: 4)
                if name[index] != "." {
                    let value = "\(name.prefix(upTo: index)).\(name.suffix(from: index))"
                    nameLbl.text = "As disciplinas do semestre \(value) ainda não foram baixadas.\nIsso tem impacto direto no score calculado."
                    return
                }
            }
            nameLbl.text = "As disciplinas do semestre \(name) ainda não foram baixadas.\nIsso tem impacto direto no score calculado."
        } else {
            nameLbl.text = "As disciplinas deste semestre ainda não foram baixadas.\nIsso tem impacto direto no score calculado."
        }
    }
    
    private func setupView() {
        contentView.addSubview(nameLbl)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            nameLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            nameLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        ])
    }
}

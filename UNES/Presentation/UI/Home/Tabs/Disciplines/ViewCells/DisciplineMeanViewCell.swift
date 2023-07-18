//
//  DisciplineMeanViewCell.swift
//  UNES
//
//  Created by João Santos Sena on 17/07/23.
//

import UIKit

class DisciplineMeanViewCell: UICollectionViewCell {
    static let identifier = "DisciplineMeanViewCell"
    
    private let descriptionLbl: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 15, weight: .medium)
        view.numberOfLines = 0
        view.text = "Média final"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let valueLbl: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16, weight: .bold)
        view.textAlignment = .right
        view.textColor = .systemMint
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
        if item.finalScore == -1 {
            valueLbl.text = "--"
        } else {
            valueLbl.text = String(format: "%.1f", item.finalScore)
        }
    }
    
    private func setupView() {
        contentView.addSubview(descriptionLbl)
        contentView.addSubview(valueLbl)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            descriptionLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            descriptionLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            valueLbl.topAnchor.constraint(equalTo: descriptionLbl.topAnchor, constant: 8),
            valueLbl.bottomAnchor.constraint(equalTo: descriptionLbl.bottomAnchor, constant: -8),
            valueLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            valueLbl.leadingAnchor.constraint(equalTo: descriptionLbl.trailingAnchor, constant: 4),
        ])
    }
}

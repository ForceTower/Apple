//
//  DisciplineMaterialViewCell.swift
//  UNES
//
//  Created by João Santos Sena on 29/07/23.
//

import UIKit

class DisciplineMaterialViewCell: UICollectionViewCell {
    static let identifier = "DisciplineMaterialViewCell"
    
    private var title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var link: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .systemBlue
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layout()
    }
    
    private func layout() {
        setupViews()
        setupConstraints()
    }
    
    func bind(_ item: ClassMaterialEntity) {
        title.text = item.name
        link.text = item.link
    }
    
    private func setupViews() {
        contentView.addSubview(title)
        contentView.addSubview(link)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            link.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 2),
            link.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            link.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            link.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
}

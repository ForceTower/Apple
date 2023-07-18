//
//  DisciplineGroupNameViewCell.swift
//  UNES
//
//  Created by João Santos Sena on 17/07/23.
//

import UIKit

class DisciplineGroupNameViewCell: UICollectionViewCell {
    static let identifier = "DisciplineGroupNameViewCell"
    
    private let groupNameLbl: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16, weight: .medium)
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
    
    func setup(_ item: ClassEntity, groupName: String) {
        groupNameLbl.text = groupName.localizedCapitalized
    }
    
    private func setupView() {
        contentView.addSubview(groupNameLbl)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            groupNameLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            groupNameLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            groupNameLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            groupNameLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        ])
    }
}

//
//  ScheduleBlockViewCell.swift
//  UNES
//
//  Created by João Santos Sena on 16/07/23.
//

import UIKit

class ScheduleBlockViewCell: UICollectionViewCell {
    static let identifier = "ScheduleBlockViewCell"
    
    private lazy var card: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        view.layer.cornerRadius = 8
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 1
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var stack: UIStackView = {
        let view = UIStackView()
        view.distribution = .fill
        view.spacing = 2
        view.axis = .vertical
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var labelCode: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12, weight: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var labelGroup: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 10, weight: .thin)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
    }
    
    func bind(_ location: ClassLocationEntity, withColor color: UIColor) {
        labelCode.text = location.group?.clazz?.discipline?.code
        labelGroup.text = location.group?.group
        
        card.backgroundColor = color.withAlphaComponent(0.15)
        card.layer.borderWidth = 1
        card.layer.borderColor = color.cgColor
        card.layer.shadowColor = color.cgColor
    }
    
    private func setupViews() {
        card.addSubview(stack)
        contentView.addSubview(card)
        stack.addArrangedSubview(labelCode)
        stack.addArrangedSubview(labelGroup)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: contentView.topAnchor),
            card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            stack.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            stack.centerYAnchor.constraint(equalTo: card.centerYAnchor)
        ])
    }
}

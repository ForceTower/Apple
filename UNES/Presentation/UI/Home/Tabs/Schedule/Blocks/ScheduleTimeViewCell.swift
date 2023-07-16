//
//  ScheduleTimeViewCell.swift
//  UNES
//
//  Created by João Santos Sena on 16/07/23.
//

import UIKit

class ScheduleTimeViewCell: UICollectionViewCell {
    static let identifier = "ScheduleTimeViewCell"
    
    private var labelStart: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12, weight: .regular)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var labelEnd: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12, weight: .regular)
        view.textAlignment = .center
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
    
    private func setupViews() {
        contentView.addSubview(stack)
        stack.addArrangedSubview(labelStart)
        stack.addArrangedSubview(labelEnd)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    func bind(_ item: TimeSpace) {
        labelStart.text = item.start
        labelEnd.text = item.end
    }
}

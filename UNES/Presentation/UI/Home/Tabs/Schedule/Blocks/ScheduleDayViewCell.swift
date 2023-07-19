//
//  ScheduleDayViewCell.swift
//  UNES
//
//  Created by João Santos Sena on 16/07/23.
//

import UIKit

class ScheduleDayViewCell: UICollectionViewCell {
    static let identifier = "ScheduleDayViewCell"
    
    private var labelDay: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12, weight: .medium)
        view.textAlignment = .center
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
        contentView.addSubview(labelDay)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            labelDay.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            labelDay.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            labelDay.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    func bind(_ item: DaySpace) {
        labelDay.text = item.day
    }
}

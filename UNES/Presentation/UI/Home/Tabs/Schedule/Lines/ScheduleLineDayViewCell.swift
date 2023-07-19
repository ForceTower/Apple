//
//  ScheduleLineDayViewCell.swift
//  UNES
//
//  Created by João Santos Sena on 19/07/23.
//

import UIKit

class ScheduleLineDayViewCell: UICollectionViewCell {
    static let identifier = "ScheduleLineDayViewCell"
    
    private let nameLbl: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14, weight: .medium)
        view.textColor = .systemYellow
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
    
    func setup(_ item: DaySpace) {
        nameLbl.text = item.day
    }
    
    private func setupView() {
        addSubview(nameLbl)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameLbl.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            nameLbl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            nameLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            nameLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
        ])
    }
}

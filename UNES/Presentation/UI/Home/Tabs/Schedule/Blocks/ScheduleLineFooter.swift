//
//  ScheduleLineFooter.swift
//  UNES
//
//  Created by João Santos Sena on 19/07/23.
//

import Foundation

import UIKit

class ScheduleLineFooter: UICollectionReusableView {
    static let identifier = "ScheduleLineFooter"
    
    private let nameLbl: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 8, weight: .light)
        view.numberOfLines = 0
        view.textAlignment = .center
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
    
    func setup(_ item: Date?) {
        if let item = item {
            nameLbl.text = "Ultima atualizacao: \(item.formatted(date: .long, time: .standard))"
        } else {
            nameLbl.text = "Nunca atualizou..."
        }
    }
    
    private func setupView() {
        addSubview(nameLbl)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameLbl.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            nameLbl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            nameLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            nameLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
        ])
    }
}

//
//  ScheduleLineLocationViewCell.swift
//  UNES
//
//  Created by João Santos Sena on 19/07/23.
//

import UIKit

class ScheduleLineLocationViewCell: UICollectionViewCell {
    static let identifier = "ScheduleLineLocationViewCell"
    
    private let startLbl: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 14, weight: .regular)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let endLbl: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14, weight: .regular)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameLbl: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14, weight: .regular)
        view.textColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let locationLbl: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12, weight: .regular)
        view.textColor = .systemGray2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let timeDiv: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let locationDiv: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let card: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.systemGray.cgColor
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 2
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
    
    func setup(_ item: ClassLocationEntity) {
        startLbl.text = item.startsAt
        endLbl.text = item.endsAt
        nameLbl.text = item.group?.clazz?.discipline?.name?.localizedCapitalized
        let code = item.group?.clazz?.discipline?.code ?? ""
        let modulo = item.modulo?.localizedCapitalized ?? ""
        let room = item.room ?? ""
        locationLbl.text = [code, modulo, room].joined(separator: "  ")
    }
    
    private func prepare() {
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        contentView.addSubview(card)
        card.addSubview(startLbl)
        card.addSubview(endLbl)
        card.addSubview(nameLbl)
        card.addSubview(locationLbl)
        card.addSubview(timeDiv)
        card.addSubview(locationDiv)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            nameLbl.topAnchor.constraint(equalTo: card.topAnchor, constant: 8),
            nameLbl.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 64),
            nameLbl.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -8),
            
            locationDiv.topAnchor.constraint(equalTo: timeDiv.topAnchor, constant: 0),
            locationDiv.heightAnchor.constraint(equalToConstant: 2),
            locationDiv.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 64),
            locationDiv.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -8),
            
            locationLbl.topAnchor.constraint(equalTo: locationDiv.bottomAnchor, constant: 4),
            locationLbl.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 64),
            locationLbl.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -8),
            locationLbl.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -8),
            
            startLbl.topAnchor.constraint(equalTo: card.topAnchor, constant: 8),
            startLbl.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 4),
            startLbl.trailingAnchor.constraint(equalTo: card.leadingAnchor, constant: 64),
            
            timeDiv.topAnchor.constraint(equalTo: startLbl.bottomAnchor, constant: 4),
            timeDiv.heightAnchor.constraint(equalToConstant: 2),
            timeDiv.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            timeDiv.trailingAnchor.constraint(equalTo: card.leadingAnchor, constant: 56),
            
            endLbl.topAnchor.constraint(equalTo: timeDiv.bottomAnchor, constant: 4),
            endLbl.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 4),
            endLbl.trailingAnchor.constraint(equalTo: card.leadingAnchor, constant: 64),
            endLbl.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -8)
        ])
    }
}

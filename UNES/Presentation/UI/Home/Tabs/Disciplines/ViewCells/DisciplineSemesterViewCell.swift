//
//  DisciplineSemesterViewCell.swift
//  UNES
//
//  Created by João Santos Sena on 18/07/23.
//

import UIKit

class DisciplineSemesterViewCell: UICollectionReusableView {
    static let identifier = "DisciplineSemesterViewCell"
    
    private let nameLbl: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 19, weight: .medium)
        view.numberOfLines = 0
        view.textAlignment = .center
        view.textColor = .systemIndigo
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
                    nameLbl.text = value
                    return
                }
            }
            nameLbl.text = name
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

//
//  MessageViewCell.swift
//  UNES
//
//  Created by João Santos Sena on 15/07/23.
//

import UIKit

class MessageViewCell: UICollectionViewCell {
    static let identifier = "MessageViewCell"
    
    private var card: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var senderGroup: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16, weight: .medium)
        view.textColor = .systemBlue
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var senderName: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12, weight: .light)
        view.textColor = .systemCyan
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var content: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var receivedAt: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 11, weight: .light)
        label.textAlignment = .right
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
    
    private func setupViews() {
        contentView.addSubview(card)
        card.addSubview(senderGroup)
        card.addSubview(senderName)
        card.addSubview(content)
        card.addSubview(receivedAt)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            senderGroup.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            senderGroup.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            senderGroup.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            senderName.topAnchor.constraint(equalTo: senderGroup.bottomAnchor, constant: 4),
            senderName.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            senderName.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: senderName.bottomAnchor, constant: 8),
            content.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            content.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            receivedAt.topAnchor.constraint(equalTo: content.bottomAnchor, constant: 8),
            receivedAt.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16),
            receivedAt.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            receivedAt.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
        ])
    }
    
    func bind(_ message: MessageEntity) {
        if let timestamp = message.timestamp {
            let calendar = Calendar.current
            let now = Date()
            
            let diff = calendar.dateComponents([.day, .hour, .minute], from: timestamp, to: now)
            
            if let days = diff.day,
               let hours = diff.hour,
               let minutes = diff.minute {
                if days > 1 {
                    receivedAt.text = "Mensagem recebida \(timestamp.formatted(date: .abbreviated, time: .shortened))"
                } else if days == 1 {
                    receivedAt.text = "Mensagem recebida \(days)d \(hours)h atrás"
                } else {
                    receivedAt.text = "Mensagem recebida \(hours)h \(minutes)m atrás"
                }
            }
        }
        
        var discipline = message.discipline
        if discipline == nil && message.senderProfile == 3 { discipline = "Secretaria Acadêmica" }
        if let group = discipline ?? message.senderName {
            senderGroup.text = group
        }
        
        if let sender = message.senderName {
            senderName.text = sender.localizedCapitalized
        }
        
        content.text = message.content
    }
    
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
//        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
//        return layoutAttributes
//    }
}

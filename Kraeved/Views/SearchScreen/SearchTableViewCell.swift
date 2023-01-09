//
//  SearchTableViewCell.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 26.11.2022.
//

import UIKit

// MARK: - SearchTableViewCell
final class SearchTableViewCell: UITableViewCell {

    // MARK: UIConstants
    struct UIConstatns {
        static let cellHeight: CGFloat = 64
        static let iconViewMargin: CGFloat = 8
        static let iconViewSize: CGFloat = 32
        static let titleLabelFontSize: CGFloat = 16
    }

    // MARK: UIProperties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIConstatns.titleLabelFontSize, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .black
        return label
    }()

    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: Public Methods
    func configurate(title: String, type: EntityType) {
        selectionStyle = .none
        backgroundColor = .clear

        for view in contentView.subviews {
            view.removeFromSuperview()
        }

        switch type {
            case .historicalEvent:
                iconView.image = UIImage(named: "sparkles")!
            case .location:
                iconView.image = UIImage(named: "globe.europe.africa.fill")!
            case .photo:
                iconView.image = UIImage(named: "photo")!
        }

        iconView.tintColor = .gray
        contentView.addSubview(iconView)
        iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstatns.iconViewMargin).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: UIConstatns.iconViewSize).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: UIConstatns.iconViewSize).isActive = true

        titleLabel.text = title
        contentView.addSubview(titleLabel)
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: UIConstatns.iconViewMargin).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }

}

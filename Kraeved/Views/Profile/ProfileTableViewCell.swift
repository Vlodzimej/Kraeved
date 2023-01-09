//
//  ProfileTableViewCell.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 27.11.2022.
//

import UIKit

// MARK: - ProfileTableViewCell
final class ProfileTableViewCell: UITableViewCell {
    
    // MARK: UIConstants
    struct UIConstatns {
        static let cellHeight: CGFloat = 64
        static let contentInset: CGFloat = 16
        static let labelFontSize: CGFloat = 16
    }

    // MARK: UIProperties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIConstatns.labelFontSize, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIConstatns.labelFontSize, weight: .regular)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Properties
    private var action: (() -> Void)?
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private Methods
    private func initialize() {
        contentView.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstatns.contentInset).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

        contentView.addSubview(valueLabel)
        valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIConstatns.contentInset).isActive = true
        valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        contentView.addSubview(actionButton)
        actionButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: UIConstatns.contentInset).isActive = true
        actionButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        actionButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight).isActive = true
        actionButton.widthAnchor.constraint(equalToConstant: contentView.frame.width / 2).isActive = true
    }
    
    @objc private func actionButtonTapped() {
        action?()
    }
    
    // MARK: Public Methods
    func configurate(viewModel: ProfileCellViewModel) {
        backgroundColor = .clear
        
        switch viewModel.type {
        case .textField:
            titleLabel.text = viewModel.title
            valueLabel.text = viewModel.value
            titleLabel.isHidden = false
            valueLabel.isHidden = false
            actionButton.isHidden = true
        case .button:
            titleLabel.isHidden = true
            valueLabel.isHidden = true
            actionButton.setTitle(NSLocalizedString("profile.logout", comment: ""), for: .normal)
            actionButton.setTitleColor(.red, for: .normal)
            actionButton.isHidden = false
            action = viewModel.action
            actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        }
    }
}

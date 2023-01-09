//
//  MessageScreenViewController.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 05.01.2023.
//

import UIKit

// MARK: - MessageScreenViewProtocol
protocol MessageScreenViewProtocol: AnyObject {
}

// MARK: - MessageScreenViewController
final class MessageScreenViewController: BaseViewController, MessageScreenViewProtocol {

    // MARK: UIConstants
    struct UIConstants {
        static let logoWidth: CGFloat = 128
        static let logoHeight: CGFloat = 160
        static let logoVerticalOffset: CGFloat = 64
    }
    
    // MARK: Properties
    private let presenter: MessageScreenPresenterProtocol
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.Common.logoSmall
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.backgroundColor = .Common.blueButton
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.setTitle("Продолжить", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()

    // MARK: UIProperties
    
    // MARK: Init
    init(presenter: MessageScreenPresenterProtocol, messageText: String) {
        self.presenter = presenter
        messageLabel.text = messageText
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("don't use storyboards!")
    }

    // MARK: VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    private func initialize() {
        view.backgroundColor = .white
        
        view.addSubview(logoImageView)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -UIConstants.logoVerticalOffset).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: UIConstants.logoWidth).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: UIConstants.logoHeight).isActive = true
        
        view.addSubview(messageLabel)
        messageLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: Constants.contentInset).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.contentInset).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.contentInset).isActive = true
        
        view.addSubview(closeButton)
        closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.contentInset).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.contentInset).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.contentInset).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight).isActive = true
    }

    // MARK: Private methods
    @objc private func closeButtonTapped() {
        presenter.dismiss()
    }

    // MARK: Public methods

}

//
//  StartScreenViewController.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 04.01.2023.
//

import UIKit
import KraevedKit

// MARK: - StartScreenViewProtocol
protocol StartScreenViewProtocol: AnyObject {
    func showCodeForm()
}

// MARK: - StartScreenViewController
final class StartScreenViewController: BaseViewController, StartScreenViewProtocol {

    // MARK: UIConstants
    struct UIConstants {
        static let closeButtonSize: CGFloat = 32
        static let formHeight: CGFloat = 200
        static let footerImageHeight: CGFloat = 200
        static let formHorizontalOffset: CGFloat = 96
    }
    
    // MARK: Properties
    private let presenter: StartScreenPresenterProtocol
    
    // MARK: UIProperties
    private let footerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.Start.horizon
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.Common.xmark, for: .normal)
        button.setTitleColor(UIColor.Common.greenMain, for: .normal)
        button.layer.cornerRadius = UIConstants.closeButtonSize / 2
        button.backgroundColor = UIColor(white: 0, alpha: 0.25)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let phoneFormView = PhoneFormView()
    
    private let codeFormView = CodeFormView()
    
    // MARK: Init
    init(presenter: StartScreenPresenterProtocol) {
        self.presenter = presenter
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
    
    override func viewDidAppear(_ animated: Bool) {
        phoneFormView.viewDidAppear()
    }

    private func initialize() {
        view.backgroundColor = .StartScreen.background
        codeFormView.isHidden = true
        
        phoneFormView.delegate = presenter
        codeFormView.delegate = presenter
        
        view.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.contentInset).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.contentInset).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: UIConstants.closeButtonSize).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: UIConstants.closeButtonSize).isActive = true
        
        view.addSubview(phoneFormView)
        phoneFormView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        phoneFormView.heightAnchor.constraint(equalToConstant: UIConstants.formHeight).isActive = true
        phoneFormView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.formHorizontalOffset).isActive = true
        phoneFormView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.formHorizontalOffset).isActive = true

        view.addSubview(codeFormView)
        codeFormView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        codeFormView.heightAnchor.constraint(equalToConstant: UIConstants.formHeight).isActive = true
        codeFormView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.formHorizontalOffset).isActive = true
        codeFormView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.formHorizontalOffset).isActive = true

        view.addSubview(footerImageView)
        footerImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        footerImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        footerImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        footerImageView.heightAnchor.constraint(equalToConstant: UIConstants.footerImageHeight).isActive = true
    }

    // MARK: Private methods
    @objc private func closeButtonTapped() {
        presenter.dismiss()
    }
    
    // MARK: Public methods
    func showCodeForm() {
        codeFormView.viewDidAppear()
        phoneFormView.isHidden = true
        codeFormView.isHidden = false
    }
}

//
//  ProfileViewController.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 27.11.2022.
//

import UIKit

// MARK: - ProfileViewProtocol
protocol ProfileViewProtocol: AnyObject {
    var tableView: UITableView { get set }
    
    func showUserData()
    func hideUserData()
}

// MARK: - ProfileViewController
final class ProfileViewController: BaseViewController, ProfileViewProtocol {

    // MARK: Properties
    private let presenter: ProfilePresenterProtocol

    // MARK: UIProperties
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.isHidden = true
        return tableView
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("profile.signIn", comment: ""), for: .normal)
        button.backgroundColor = .Common.blueButton
        button.layer.cornerRadius = Constants.buttonRadius
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    // MARK: Init
    init(presenter: ProfilePresenterProtocol) {
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
        presenter.viewDidLoad()
    }

    // MARK: Private methods
    private func initialize() {
        view.backgroundColor = .white

        view.addSubview(tableView)

        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.contentInset).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.contentInset).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        view.addSubview(loginButton)
        loginButton.widthAnchor.constraint(equalToConstant: 128).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight).isActive = true
    }
    
    @objc private func loginButtonTapped() {
        presenter.openStartScreen()
    }

    // MARK: Public methods
    func showUserData() {
        tableView.isHidden = false
        loginButton.isHidden = true
    }
    
    func hideUserData() {
        tableView.isHidden = true
        loginButton.isHidden = false
    }
}

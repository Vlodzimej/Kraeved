//
//  ProfilePresenter.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 27.11.2022.
//

import UIKit

// MARK: - ProfilePresenterProtocol
protocol ProfilePresenterProtocol: AnyObject, ProfileTableAdapterDelegate, StartScreenModuleOutput {
    func viewDidLoad()
    func openStartScreen()
    func showUserData()
    func hideUserData()
}

// MARK: - ProfilePresenter
final class ProfilePresenter: ProfilePresenterProtocol {

    // MARK: Properties
    weak var view: ProfileViewProtocol?
    private let interactor: ProfileInteractorProtocol
    private let router: ProfileRouterProtocol

    private let adapter = ProfileTableAdapter()
    
    private let hasRegisteredUser: Bool = false

    // MARK: Init
    init(interactor: ProfileInteractorProtocol, router: ProfileRouterProtocol) {
        self.router = router
        self.interactor = interactor
    }

    // MARK: Public Methods
    func viewDidLoad() {
        adapter.delegate = self
        interactor.getUserData()
    }
    
    func configurate() {
        guard let currentUser = interactor.currentUser, let view else { return }
        adapter.setup(tableView: view.tableView)
        adapter.configurate(user: currentUser)
    }
    
    func openStartScreen() {
        router.openStartScreen(output: self)
    }
    
    func showUserData() {
        configurate()
        view?.showUserData()
    }
    
    func hideUserData() {
        view?.hideUserData()
    }
}

extension ProfilePresenter: ProfileTableAdapterDelegate {
    func logout() {
        interactor.logout()
    }
}

extension ProfilePresenter: StartScreenModuleOutput {
    func logged() {
        interactor.getUserData()
    }
}

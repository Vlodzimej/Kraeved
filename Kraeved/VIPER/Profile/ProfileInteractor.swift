//
//  ProfileInteractor.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 27.11.2022.
//

import Foundation

// MARK: - ProfileInteractorProtocol
protocol ProfileInteractorProtocol: AnyObject {
    var currentUser: User? { get set }
    
    func getUserData()
    func logout()
}

// MARK: - ProfileInteractor
final class ProfileInteractor: ProfileInteractorProtocol {

    // MARK: Properties
    weak var presenter: ProfilePresenterProtocol?
    
    private let authManager: AuthManagerProtocol

    var currentUser: User?

    // MARK: Init
    init(authManager: AuthManagerProtocol = AuthManager.shared) {
        self.authManager = authManager
    }

    // MARK: Private Methods

    // MARK: Public Methods
    func getUserData() {
        if let phone = authManager.getUserData() {
            let formattedPhone = formatPhoneNumber(with: Constants.phoneMask, phone: phone)
            currentUser = User(username: "Default User", email: "default@mail.ru", phone: formattedPhone, score: 100)
            presenter?.showUserData()
        } else {
            presenter?.hideUserData()
        }
    }
    
    func logout() {
        authManager.logout()
        presenter?.hideUserData()
    }
}

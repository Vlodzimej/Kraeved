//
//  StartScreenInteractor.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 04.01.2023.
//

import Foundation

// MARK: - StartScreenInteractorProtocol
protocol StartScreenInteractorProtocol: AnyObject {
    func login(phone: String, code: String)
}

// MARK: - StartScreenInteractor
final class StartScreenInteractor: StartScreenInteractorProtocol {

    private let authManager: AuthManagerProtocol
    // MARK: Properties
    weak var presenter: StartScreenPresenterProtocol?

    // MARK: Init
    init(authManager: AuthManagerProtocol = AuthManager.shared) {
        self.authManager = authManager
        authManager.logout()
    }

    // MARK: Private Methods

    // MARK: Public Methods
    func login(phone: String, code: String) {
        let result = authManager.login(phone: phone, code: code)
        if result {
            presenter?.logged()
        }
    }
}

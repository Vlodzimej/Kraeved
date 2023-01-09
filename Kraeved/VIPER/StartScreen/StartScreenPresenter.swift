//
//  StartScreenPresenter.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 04.01.2023.
//

import UIKit

protocol StartScreenModuleOutput: AnyObject {
    func logged()
}

// MARK: - StartScreenPresenterProtocol
protocol StartScreenPresenterProtocol: AnyObject, PhoneFormViewDelegate, CodeFormViewDelegate {
    func dismiss()
    func logged()
}

// MARK: - StartScreenPresenter
final class StartScreenPresenter: StartScreenPresenterProtocol {

    // MARK: Properties
    weak var view: StartScreenViewProtocol?
    private let interactor: StartScreenInteractorProtocol
    private let router: StartScreenRouterProtocol
    private let output: StartScreenModuleOutput?
    
    private var phone: String?

    // MARK: Init
    init(interactor: StartScreenInteractorProtocol, router: StartScreenRouterProtocol, output: StartScreenModuleOutput?) {
        self.router = router
        self.interactor = interactor
        self.output = output
    }
    
    func dismiss() {
        router.dismiss()
    }
    
    func logged() {
        output?.logged()
    }
}

extension StartScreenPresenter: PhoneFormViewDelegate {
    func sendPhone(_ phone: String) {
        self.phone = phone
        view?.showCodeForm()
    }
}

extension StartScreenPresenter: CodeFormViewDelegate {
    func sendCode(_ code: String) {
        guard let phone else { return }
        interactor.login(phone: phone, code: code)
        router.dismiss()
    }
}

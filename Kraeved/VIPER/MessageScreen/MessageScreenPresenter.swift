//
//  MessageScreenPresenter.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 05.01.2023.
//

import UIKit

// MARK: - MessageScreenPresenterProtocol
protocol MessageScreenPresenterProtocol: AnyObject {
    func dismiss()
}

// MARK: - MessageScreenPresenter
final class MessageScreenPresenter: MessageScreenPresenterProtocol {

    // MARK: Properties
    weak var view: MessageScreenViewProtocol?
    private let interactor: MessageScreenInteractorProtocol
    private let router: MessageScreenRouterProtocol

    // MARK: Init
    init(interactor: MessageScreenInteractorProtocol, router: MessageScreenRouterProtocol) {
        self.router = router
        self.interactor = interactor
    }
    
    func dismiss() {
        router.dismiss()
    }
}

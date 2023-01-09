//
//  GenealogyPresenter.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 06.01.2023.
//

import UIKit

// MARK: - GenealogyPresenterProtocol
protocol GenealogyPresenterProtocol: AnyObject {
}

// MARK: - GenealogyPresenter
final class GenealogyPresenter: GenealogyPresenterProtocol {

    // MARK: Properties
    weak var view: GenealogyViewProtocol?
    private let interactor: GenealogyInteractorProtocol
    private let router: GenealogyRouterProtocol

    // MARK: Init
    init(interactor: GenealogyInteractorProtocol, router: GenealogyRouterProtocol) {
        self.router = router
        self.interactor = interactor
    }
}

//
//  MiniAppsScreenInteractor.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 24.12.2022.
//

import Foundation

// MARK: - MiniAppsScreenInteractorProtocol
protocol MiniAppsScreenInteractorProtocol: AnyObject {
}

// MARK: - MiniAppsScreenInteractor
final class MiniAppsScreenInteractor: MiniAppsScreenInteractorProtocol {

    // MARK: Properties
    weak var presenter: MiniAppsScreenPresenterProtocol?

    // MARK: Init
    init() {
    }

    // MARK: Private Methods

    // MARK: Public Methods
}

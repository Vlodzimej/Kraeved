//
//  GenealogyInteractor.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 06.01.2023.
//

import Foundation

// MARK: - GenealogyInteractorProtocol
protocol GenealogyInteractorProtocol: AnyObject {
}

// MARK: - GenealogyInteractor
final class GenealogyInteractor: GenealogyInteractorProtocol {

    // MARK: Properties
    weak var presenter: GenealogyPresenterProtocol?

    // MARK: Init
    init() {
    }

    // MARK: Private Methods

    // MARK: Public Methods
}

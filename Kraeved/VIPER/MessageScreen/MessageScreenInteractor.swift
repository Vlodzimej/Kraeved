//
//  MessageScreenInteractor.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 05.01.2023.
//

import UIKit

// MARK: - MessageScreenInteractorProtocol
protocol MessageScreenInteractorProtocol: AnyObject {
}

// MARK: - MessageScreenInteractor
final class MessageScreenInteractor: MessageScreenInteractorProtocol {

    // MARK: Properties
    weak var presenter: MessageScreenPresenterProtocol?
    
    // MARK: Init
    init() {
    }

    // MARK: Private Methods

    // MARK: Public Methods
}

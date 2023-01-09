//
//  MessageScreenModuleBuilder.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 05.01.2023.
//

import Foundation

final class MessageScreenModuleBuilder {
    static func build(messageText: String) -> MessageScreenViewController {
		let interactor = MessageScreenInteractor()
		let router = MessageScreenRouter()
		let presenter = MessageScreenPresenter(interactor: interactor, router: router)
		let viewController = MessageScreenViewController(presenter: presenter, messageText: messageText)
		router.viewController = viewController
		presenter.view = viewController
		interactor.presenter = presenter
		return viewController
	}
}

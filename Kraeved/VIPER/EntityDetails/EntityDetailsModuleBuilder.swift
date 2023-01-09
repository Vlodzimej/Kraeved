//
//  EntityDetailsModuleBuilder.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 23.11.2022.
//

import Foundation

final class EntityDetailsModuleBuilder {
    static func build(id: UUID) -> EntityDetailsViewController {
		let interactor = EntityDetailsInteractor()
		let router = EntityDetailsRouter()
		let presenter = EntityDetailsPresenter(interactor: interactor, router: router, id: id)
		let viewController = EntityDetailsViewController(presenter: presenter)
		router.viewController = viewController
		presenter.view = viewController
		interactor.presenter = presenter
		return viewController
	}
}

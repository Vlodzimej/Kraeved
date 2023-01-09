//
//  MiniAppsScreenModuleBuilder.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 24.12.2022.
//

import Foundation

final class MiniAppsScreenModuleBuilder {
	static func build() -> MiniAppsScreenViewController {
		let interactor = MiniAppsScreenInteractor()
		let router = MiniAppsScreenRouter()
		let presenter = MiniAppsScreenPresenter(interactor: interactor, router: router)
		let viewController = MiniAppsScreenViewController(presenter: presenter)
		router.viewController = viewController
		presenter.view = viewController
		interactor.presenter = presenter
		return viewController
	}
}

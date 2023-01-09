//
//  GenealogyModuleBuilder.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 06.01.2023.
//

import Foundation

final class GenealogyModuleBuilder {
	static func build() -> GenealogyViewController {
		let interactor = GenealogyInteractor()
		let router = GenealogyRouter()
		let presenter = GenealogyPresenter(interactor: interactor, router: router)
		let viewController = GenealogyViewController(presenter: presenter)
		router.viewController = viewController
		presenter.view = viewController
		interactor.presenter = presenter
		return viewController
	}
}

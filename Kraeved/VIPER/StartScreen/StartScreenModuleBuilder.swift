//
//  StartScreenModuleBuilder.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 04.01.2023.
//

import Foundation

final class StartScreenModuleBuilder {
    static func build(output: StartScreenModuleOutput? = nil) -> StartScreenViewController {
		let interactor = StartScreenInteractor()
		let router = StartScreenRouter()
        let presenter = StartScreenPresenter(interactor: interactor, router: router, output: output)
		let viewController = StartScreenViewController(presenter: presenter)
		router.viewController = viewController
		presenter.view = viewController
		interactor.presenter = presenter
		return viewController
	}
}

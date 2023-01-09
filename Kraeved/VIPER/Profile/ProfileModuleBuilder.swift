//
//  ProfileModuleBuilder.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 27.11.2022.
//

import Foundation

final class ProfileModuleBuilder {
	static func build() -> ProfileViewController {
		let interactor = ProfileInteractor()
		let router = ProfileRouter()
		let presenter = ProfilePresenter(interactor: interactor, router: router)
		let viewController = ProfileViewController(presenter: presenter)
		router.viewController = viewController
		presenter.view = viewController
		interactor.presenter = presenter
		return viewController
	}
}

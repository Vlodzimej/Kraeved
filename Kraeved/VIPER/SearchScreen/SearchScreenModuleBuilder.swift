import UIKit

final class SearchScreenModuleBuilder {
	static func build() -> UIViewController {
		let interactor = SearchScreenInteractor()
		let router = SearchScreenRouter()
		let presenter = SearchScreenPresenter(interactor: interactor, router: router)
		let viewController = SearchScreenViewController(presenter: presenter)
		router.viewController = viewController
		presenter.view = viewController
		interactor.presenter = presenter
		return viewController
	}
}

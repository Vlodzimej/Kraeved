import UIKit

final class MainScreenModuleBuilder {
    static func build() -> UIViewController {
        let interactor = MainScreenInteractor()
        let router = MainScreenRouter()
        let presenter = MainScreenPresenter(interactor: interactor, router: router)
        let viewController = MainScreenViewController(presenter: presenter)
        router.viewController = viewController
        presenter.view = viewController
        interactor.presenter = presenter
        return viewController
    }
}

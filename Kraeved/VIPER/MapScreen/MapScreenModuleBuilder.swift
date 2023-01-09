import UIKit

final class MapScreenModuleBuilder {
    static func build() -> UIViewController {
        let interactor = MapScreenInteractor()
        let router = MapScreenRouter()
        let presenter = MapScreenPresenter(interactor: interactor, router: router)
        let viewController = MapScreenViewController(presenter: presenter)
        router.viewController = viewController
        presenter.view = viewController
        interactor.presenter = presenter
        return viewController
    }
}

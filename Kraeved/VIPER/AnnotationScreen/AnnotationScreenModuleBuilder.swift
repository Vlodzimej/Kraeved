import UIKit

final class AnnotationScreenModuleBuilder {
    static func build(annotation: Annotation) -> UIViewController {
		let interactor = AnnotationScreenInteractor()
		let router = AnnotationScreenRouter()
        let presenter = AnnotationScreenPresenter(interactor: interactor, router: router, annotation: annotation)
		let viewController = AnnotationScreenViewController(presenter: presenter)
		router.viewController = viewController
		presenter.view = viewController
		interactor.presenter = presenter
		return viewController
	}
}

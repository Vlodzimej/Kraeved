import UIKit

// MARK: - AnnotationScreenPresenterProtocol
protocol AnnotationScreenPresenterProtocol: AnyObject {
    var annotation: Annotation { get }
}

// MARK: - AnnotationScreenPresenter
final class AnnotationScreenPresenter: AnnotationScreenPresenterProtocol {

    // MARK: Properties
    weak var view: AnnotationScreenViewProtocol?
    private let interactor: AnnotationScreenInteractorProtocol
    private let router: AnnotationScreenRouterProtocol
    var annotation: Annotation

    // MARK: Init
    init(interactor: AnnotationScreenInteractorProtocol, router: AnnotationScreenRouterProtocol, annotation: Annotation) {
        self.router = router
        self.interactor = interactor
        self.annotation = annotation
    }
}

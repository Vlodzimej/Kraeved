import Foundation

// MARK: - AnnotationScreenInteractorProtocol
protocol AnnotationScreenInteractorProtocol: AnyObject {
}

// MARK: - AnnotationScreenInteractor
final class AnnotationScreenInteractor: AnnotationScreenInteractorProtocol {

    // MARK: Properties
    weak var presenter: AnnotationScreenPresenterProtocol?

    // MARK: Init
    init() {
    }
}

import MapKit

// MARK: - MapScreenInteractorProtocol
protocol MapScreenInteractorProtocol: AnyObject {
    var hasAuthorization: Bool { get }
    
    func getAnnotations()
    func getEntity(id: UUID, completion: @escaping (MetaObject<Entity>) -> Void)
    func addAnnotation(_ annotation: Annotation, completion: @escaping (Annotation) -> Void)
}

// MARK: - MapScreenInteractor
final class MapScreenInteractor: MapScreenInteractorProtocol {

    private let annotationManager: AnnotationManagerProtocol
    private let entityManager: EntityManagerProtocol
    private let authManager: AuthManagerProtocol

    private var annotations: [Annotation] = []

    // MARK: Properties
    weak var presenter: MapScreenPresenterProtocol?
    
    var hasAuthorization: Bool {
        authManager.getUserData() != nil
    }

    // MARK: Init
    init(annotationManager: AnnotationManagerProtocol = AnnotationManager.shared, entityManager: EntityManagerProtocol = EntityManager.shared, authManager: AuthManagerProtocol = AuthManager.shared) {
        self.annotationManager = annotationManager
        self.entityManager = entityManager
        self.authManager = authManager
    }

    // MARK: Public Methods
    func getAnnotations() {
        annotationManager.getAnnotations { [weak self] annotations in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.presenter?.addAnnotations(annotations: annotations)
            }
        }
    }

    func getEntity(id: UUID, completion: @escaping (MetaObject<Entity>) -> Void) {
        self.entityManager.get(id: id) { entities in
            completion(entities)
        }
    }
    
    func addAnnotation(_ annotation: Annotation, completion: @escaping (Annotation) -> Void) {
        annotationManager.addAnnotation(annotation) { result in
            completion(result)
        }
    }
}

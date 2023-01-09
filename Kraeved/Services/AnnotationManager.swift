//
//  AnnotationManager.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 09.11.2022.
//

import MapKit

// MARK: - AnnotationManagerProtocol
protocol AnnotationManagerProtocol {
    func getAnnotations(completion: @escaping ([Annotation]) -> Void)
    func addAnnotation(_ annotation: Annotation, completion: @escaping (Annotation) -> Void)
}

// MARK: - AnnotationManager
final class AnnotationManager: AnnotationManagerProtocol {

    // MARK: Properties
    static let shared = AnnotationManager()

    private let entityManager: EntityManagerProtocol

    // MARK: Init
    private init(entityManager: EntityManagerProtocol = EntityManager.shared) {
        self.entityManager = entityManager
    }

    // MARK: Public Methods
    func getAnnotations(completion: @escaping ([Annotation]) -> Void) {
        entityManager.find(customProperties: ["typeId": EntityType.location.rawValue]) { locations in
            let annotations: [Annotation] = locations.compactMap { Annotation($0) }
            completion(annotations)
        }
    }
    
    func addAnnotation(_ annotation: Annotation, completion: @escaping (Annotation) -> Void) {
        guard let entity = annotation.convertToEntity() else { return }
        entityManager.add(entity: entity) { result in
            completion(Annotation(result))
        }
    }
}

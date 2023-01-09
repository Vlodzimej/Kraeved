//
//  EntityDetailsInteractorProtocol.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 23.11.2022.
//

import Foundation

// MARK: - EntityDetailsInteractorProtocol
protocol EntityDetailsInteractorProtocol: AnyObject {
    func getEntity(id: UUID, completion: @escaping (MetaObject<Entity>) -> Void)
}

// MARK: - EntityDetailsInteractor
final class EntityDetailsInteractor: EntityDetailsInteractorProtocol {

    // MARK: Properties
    weak var presenter: EntityDetailsPresenterProtocol?

    private let businessObjectManager: BusinessObjectManagerProtocol
    private let imageManager: ImageManagerProtocol

    // MARK: Init
    init(businessObjectManager: BusinessObjectManagerProtocol = BusinessObjectManager.shared, imageManager: ImageManagerProtocol = ImageManager.shared) {
        self.businessObjectManager = businessObjectManager
        self.imageManager = imageManager
    }

    // MARK: Private Methods

    // MARK: Public Methods
    func getEntity(id: UUID, completion: @escaping (MetaObject<Entity>) -> Void) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            self.businessObjectManager.find(metaTypeId: MetaType.entity.id, predicates: [NSPredicate(format: "%K = %@", "id", id.uuidString)]) { businessObjects in
                guard let businessObject = businessObjects.first,
                      let entity: MetaObject<Entity> = businessObject.convertToMetaObject() else { return }
                if entity.data?.typeId?.uuidString == EntityType.photo.rawValue, let imageUrl = entity.data?.imageUrl, let url = URL(string: imageUrl) {
                    self.imageManager.downloadImage(from: url) { image in
                        let resultEntity = MetaObject<Entity>(id: entity.id, title: entity.title, image: image, data: entity.data)
                        completion(resultEntity)
                    }
                }
                completion(entity)
            }
        }
    }
}

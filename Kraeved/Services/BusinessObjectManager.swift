//
//  BusinessObjectManager.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 25.11.2022.
//

import Foundation
import CoreData

// MARK: - BusinessObjectManagerProtocol
protocol BusinessObjectManagerProtocol: AnyObject {
    func get(metaTypeId: UUID, completion: @escaping ([BusinessObject]) -> Void)
    func find(metaTypeId: UUID, predicates: [NSPredicate], completion: @escaping ([BusinessObject]) -> Void)
    func add(_ businessObject: BusinessObject, completion: @escaping (BusinessObject) -> Void)
}

// MARK: - BusinessObjectManager
final class BusinessObjectManager: BusinessObjectManagerProtocol {
    struct Constants {
        static let entityName: String = "BusinessObjectCoreModel"
    }

    static let shared = BusinessObjectManager()

    // MARK: Properties
    private let apiManager: APIManager
    private let coreDataManager: CoreDataManagerProtocol

    // MARK: Init
    private init(apiManager: APIManager = APIManager.shared, coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared) {
        self.apiManager = apiManager
        self.coreDataManager = coreDataManager
    }

    // MARK: Public Methods
    /**
     Получение и кэширование бизнес-объектов
    */
    func get(metaTypeId: UUID, completion: @escaping ([BusinessObject]) -> Void) {
        guard let url =  URL(string: "http://178.250.159.110/api/BusinessObject/metaTypeId/\(metaTypeId.uuidString)") else { return }
        let request = URLRequest(url: url)
        apiManager.get(with: request) { (response: Result<[BusinessObject], Error>) in
            switch response {
            case .success(let businessObjects):
                businessObjects.forEach { BusinessObjectCoreModel($0) }
                self.coreDataManager.saveContext()
                completion(businessObjects)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }

    /**
     Поиск по кэшированным бизнес-объектам
     */
    func find(metaTypeId: UUID, predicates: [NSPredicate], completion: @escaping ([BusinessObject]) -> Void) {
        let concurrentQueue = DispatchQueue(label: "kraeved-concurrent-queue")
        concurrentQueue.async { [weak self] in
            guard let self else { return }
            var subPredicates = [NSPredicate(format: "%K = %@", "metaTypeId", metaTypeId.uuidString)]
            subPredicates += predicates
            let result = self.coreDataManager.find(entityName: Constants.entityName, predicates: subPredicates)
            let businessObjects: [BusinessObject] = result.compactMap { item in
                guard let item = item as? BusinessObjectCoreModel else { return nil }
                return BusinessObject(item)
            }
            completion(businessObjects)
        }
    }
    
    /**
     Добавление нового бизнес-объекта
     */
    func add(_ businessObject: BusinessObject, completion: @escaping (BusinessObject) -> Void) {
        let concurrentQueue = DispatchQueue(label: "kraeved-concurrent-queue")
        concurrentQueue.async { [weak self] in
            guard let self, let id = businessObject.id?.uuidString else { return }
            BusinessObjectCoreModel(businessObject)
            self.coreDataManager.saveContext()
            let subPredicates = [NSPredicate(format: "%K = %@", "id", id)]
            let result = self.coreDataManager.find(entityName: Constants.entityName, predicates: subPredicates)
            guard let item = result.first, let coreDataObject = item as? BusinessObjectCoreModel else { return }
            let businessObject = BusinessObject(coreDataObject)
            completion(businessObject)
        }
    }
}

//
//  BusinessObjectManagerMock.swift
//  KraevedTests
//
//  Created by Владимир Амелькин on 21.12.2022.
//

import Foundation
@testable import Kraeved

class BusinessObjectManagerMock: BusinessObjectManagerProtocol {
    let uuids: [UUID] = [
        UUID(uuidString: "21af1cad-7a20-427a-a9c7-c4bafcfffc79") ?? UUID(),
        UUID(uuidString: "b54abb07-910d-4ab6-afb4-968408e32208") ?? UUID(),
        UUID(uuidString: "aad247c5-00fe-490a-b81b-8a33e65ffff9") ?? UUID()
    ]

    lazy var businessObjects: [BusinessObject] = [
        .init(id: uuids[0], title: "Тестовый БО-1", metaTypeId: MetaType.entity.id, customProperties: "{ \"text\": \"Тестовый текст\" }", startDate: "", finishDate: ""),
        .init(id: uuids[1], title: "Тестовый БО-2", metaTypeId: MetaType.entity.id, customProperties: "", startDate: "", finishDate: ""),
        .init(id: uuids[2], title: "Тестовый БО-3", metaTypeId: UUID(), customProperties: "", startDate: "", finishDate: "")
    ]

    func get(metaTypeId: UUID, completion: @escaping ([Kraeved.BusinessObject]) -> Void) {
        completion(businessObjects)
    }
    
    func find(metaTypeId: UUID, predicates: [NSPredicate], completion: @escaping ([Kraeved.BusinessObject]) -> Void) {
        let result = businessObjects.filter { $0.metaTypeId == metaTypeId }
        completion(result)
    }
    
    func add(_ businessObject: Kraeved.BusinessObject, completion: @escaping (Kraeved.BusinessObject) -> Void) {
        completion(businessObject)
    }
}

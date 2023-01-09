//
//  EntityManagerTest.swift
//  KraevedTests
//
//  Created by Владимир Амелькин on 21.12.2022.
//

import XCTest
@testable import Kraeved

final class EntityManagerTest: XCTestCase {

    var entityManager: EntityManagerProtocol!

    override func setUpWithError() throws {
        let businessObjectManager = BusinessObjectManagerMock()
        let imageManager = ImageManagerMock()

        entityManager = EntityManager(businessObjectManager: businessObjectManager, imageManager: imageManager)
    }

    override func tearDownWithError() throws {
        entityManager = nil
    }

    func testGetEntities() throws {
        entityManager.getAll { entities in
            XCTAssertEqual(entities.count, 3, "entities count must be 3")
        }
    }

    func testGetEntity() throws {
        guard let uuid = UUID(uuidString: "21af1cad-7a20-427a-a9c7-c4bafcfffc79") else { return }
        entityManager.get(id: uuid) { entity in
            XCTAssertEqual(entity.title, "Тестовый БО-1", "entity title must containts string: 'Тестовый БО-1'")
        }
    }

    func testCustomProperties() throws {
        guard let uuid = UUID(uuidString: "21af1cad-7a20-427a-a9c7-c4bafcfffc79") else { return }
        entityManager.get(id: uuid) { entity in
            XCTAssertEqual(entity.data?.text, "Тестовый текст", "entity data text field must containts string: 'Тестовый текст'")
        }
    }
    
    func testAddEntity() throws {
        let longitude: CLongDouble = 54.534749
        let latitude: CLongDouble = 36.285591
        let data = Entity(imageUrl: "http://test.ru/test.png", text: "Тестовое имя", typeId: EntityType.location.id, longitude: longitude, latitude: latitude)
        let entity: MetaObject<Entity> = MetaObject<Entity>(id: UUID(), title: "Тестовая запись", image: nil, data: data)
        entityManager.add(entity: entity) { entity in
            let comparedData = Entity(imageUrl: "http://test.ru/test.png", text: "Тестовое имя", typeId: EntityType.location.id, longitude: longitude, latitude: latitude)
            XCTAssertEqual(entity.data, comparedData, "added and returned entity data must equals comparedData")
        }
    }
}

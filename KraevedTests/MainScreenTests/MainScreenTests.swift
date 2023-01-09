//
//  MainScreenTests.swift
//  KraevedTests
//
//  Created by Владимир Амелькин on 20.12.2022.
//

import XCTest
@testable import Kraeved

final class MainScreenTests: XCTestCase {

    var presenter: MainScreenPresenter!
    var view: MainScreenViewControllerMock?
    var interactor: MainScreenInteractorMock?
    var router: MainScreenRouterMock?

    override func setUpWithError() throws {
        view = MainScreenViewControllerMock()
        interactor = MainScreenInteractorMock()
        router = MainScreenRouterMock()
        guard let interactor = interactor, let router = router else { return }

        presenter = MainScreenPresenter(interactor: interactor, router: router)
        presenter.view = view
    }

    override func tearDownWithError() throws {
        presenter = nil
    }

    func testOpenEntityDetailsCalling() {
        guard let router = router else { return }
        presenter.showEntityDetails(id: UUID())

        if !router.isEntityDetailsOpened {
            XCTFail("openEntityDetails func not called")
        }
    }

    func testFetchEntitiesCalling() {
        guard let interactor = interactor else { return }
        presenter.viewDidLoad()

        if interactor.entities == nil {
            XCTFail("fetchEntities func not called")
        }
    }
}

class MainScreenViewControllerMock: MainScreenViewProtocol {
    var tableView: UITableView = UITableView()
}

class MainScreenInteractorMock: MainScreenInteractorProtocol {
    var entities: [Kraeved.MetaObject<Kraeved.Entity>]?

    func fetchEntities(completion: @escaping ([Kraeved.MetaObject<Kraeved.Entity>]) -> Void) {
        let data: [Kraeved.MetaObject<Kraeved.Entity>] = [
            .init(id: UUID(), title: "Тестовый объект 1", image: UIImage(), data: Entity(imageUrl: "http://testimageurl1", text: "Тестовый тескт 1", typeId: MetaType.entity.id)),
            .init(id: UUID(), title: "Тестовый объект 2", image: UIImage(), data: Entity(imageUrl: "http://testimageurl2", text: "Тестовый тескт 2", typeId: MetaType.entity.id))
        ]
        entities = data
        completion(data)
    }
}

class MainScreenRouterMock: BaseRouterMock {
}

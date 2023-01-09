import Foundation

// MARK: - SearchItem
struct SearchItem {
    let id: UUID
    let title: String
    let type: EntityType
}

// MARK: - SearchScreenInteractorProtocol
protocol SearchScreenInteractorProtocol: AnyObject {
    var items: [SearchItem] { get set }

    func search(metaType: MetaType, searchText: String)
}

// MARK: - SearchScreenInteractor
final class SearchScreenInteractor: SearchScreenInteractorProtocol {

    // MARK: Properties
    weak var presenter: SearchScreenPresenterProtocol?
    private let historicalEventsManager: EntityManagerProtocol

    var items: [SearchItem] = []

    // MARK: Init
    init(historicalEventsManager: EntityManagerProtocol = EntityManager.shared) {
        self.historicalEventsManager = historicalEventsManager
    }

    func search(metaType: MetaType, searchText: String) {
        historicalEventsManager.find(title: searchText) { [weak self] metaObjects in
            guard let self = self else { return }
            self.items = metaObjects.compactMap { item in
                guard let title = item.title, let type = EntityType.allCases.first(where: { $0.rawValue.uppercased() == item.data?.typeId?.uuidString }) else { return nil }
                return SearchItem(id: item.id, title: title, type: type)
            }
            self.presenter?.update()
        }
    }
}

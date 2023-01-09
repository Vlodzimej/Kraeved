import UIKit

// MARK: - MainScreenPresenterProtocol
protocol MainScreenPresenterProtocol: AnyObject {
    func viewDidLoad()
}

// MARK: - MainScreenPresenter
final class MainScreenPresenter: NSObject, MainScreenPresenterProtocol {

    private let adapter = MainTableAdapter()

    // MARK: Properties
    weak var view: MainScreenViewProtocol?
    private let interactor: MainScreenInteractorProtocol
    private let router: MainScreenRouterProtocol

    var baseView: BaseViewProtocol? {
        view as? BaseViewProtocol
    }

    // MARK: Init
    init(interactor: MainScreenInteractorProtocol, router: MainScreenRouterProtocol) {
        self.router = router
        self.interactor = interactor
        super.init()
    }

    func viewDidLoad() {
        guard let view = view else { return }
        adapter.delegate = self
        adapter.setup(for: view.tableView)

        baseView?.isActivityIndicatorHidden = false
        interactor.fetchEntities { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.baseView?.showOnboarding()
                self.baseView?.isActivityIndicatorHidden = true
                self.adapter.configurate(entities: result)
            }
        }
    }
}

extension MainScreenPresenter: MainTableAdapterDelegate {
    func showEntityDetails(id: UUID) {
        router.openEntityDetails(id: id)
    }
}

import UIKit

// MARK: - MainScreenViewProtocol
protocol MainScreenViewProtocol: AnyObject {
    var tableView: UITableView { get set }
}

// MARK: - MainScreenViewController
final class MainScreenViewController: BaseViewController, MainScreenViewProtocol {
    // MARK: Properties
    private let presenter: MainScreenPresenterProtocol

    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        return tableView
    }()

    // MARK: UIProperties

    // MARK: Init
    init(presenter: MainScreenPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("don't use storyboards!")
    }

    // MARK: VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
        initialize()
    }

    private func initialize() {
        view.backgroundColor = UIColor.MainScreen.background
        navigationController?.setNavigationBarHidden(true, animated: false)

        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none

        view.addSubview(tableView)

        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    // MARK: Private methods

    // MARK: Public methods

}

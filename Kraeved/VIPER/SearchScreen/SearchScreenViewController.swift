import UIKit

// MARK: - SearchScreenViewProtocol
protocol SearchScreenViewProtocol: AnyObject {
    var tableView: UITableView { get set }
}

private struct SearchTypes {
    let title: String
    let metaType: MetaType
}

// MARK: - SearchScreenViewController
final class SearchScreenViewController: BaseViewController, SearchScreenViewProtocol {

    // MARK: Properties
    private let presenter: SearchScreenPresenterProtocol

    private let searchTypes: [SearchTypes] = [
        SearchTypes(title: NSLocalizedString("searchItems.historicalEvents", comment: ""), metaType: .entity),
        SearchTypes(title: NSLocalizedString("searchItems.annotations", comment: ""), metaType: .entity)
    ]

    // MARK: UIProperties
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.backgroundColor = .white
        if let textField = searchBar.value(forKey: "searchField") as? UITextField,
            let iconView = textField.leftView as? UIImageView {
            textField.textColor = .black
            iconView.tintColor = .black
        }
        return searchBar
    }()

    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        return tableView
    }()

    // MARK: Init
    init(presenter: SearchScreenPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("don't use storyboards!")
    }

    // MARK: VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        presenter.currentMetaType = searchTypes[0].metaType
        presenter.viewDidLoad()
    }

    private func initialize() {
        view.backgroundColor = .white
        navigationItem.titleView = searchBar

        view.addSubview(tableView)

        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.contentInset).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.contentInset).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension SearchScreenViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.search(metaType: MetaType.entity, searchText: searchText)
    }
}

import UIKit

// MARK: - AnnotationScreenViewProtocol
protocol AnnotationScreenViewProtocol: AnyObject {
}

// MARK: - AnnotationScreenViewController
final class AnnotationScreenViewController: BaseViewController, AnnotationScreenViewProtocol {

    // MARK: UIConstants
    struct UIConstants {
        static let titleLabelFontSize: CGFloat = 24
        static let coordsLabelFontSize: CGFloat = 8
    }
    
    // MARK: Properties
    private let presenter: AnnotationScreenPresenterProtocol

    // MARK: UIProperties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: UIConstants.titleLabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()

    private let coordsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: UIConstants.coordsLabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()

    // MARK: Init
    init(presenter: AnnotationScreenPresenterProtocol) {
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
    }

    private func initialize() {
        view.backgroundColor = .white
        titleLabel.text = presenter.annotation.title
        coordsLabel.text = "\(presenter.annotation.coordinate.latitude) \(presenter.annotation.coordinate.longitude)"

        view.addSubview(titleLabel)

        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        view.addSubview(coordsLabel)

        coordsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        coordsLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true

        // view.layoutIfNeeded()
    }
}

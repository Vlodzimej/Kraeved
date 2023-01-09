//
//  EntityDetailsViewController.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 23.11.2022.
//

import UIKit

// MARK: - EntityDetailsViewProtocol
protocol EntityDetailsViewProtocol: AnyObject {
    func update(entity: MetaObject<Entity>)
}

// MARK: - EntityDetailsViewController
final class EntityDetailsViewController: BaseViewController, EntityDetailsViewProtocol {

    // MARK: UIConstants
    struct UIConstants {
        static let titleLabelFontSize: CGFloat = 24
        static let titleLabelTopOffset: CGFloat = 128
        static let textLabelTopOffset: CGFloat = 64
        static let descriptionLabelFontSize: CGFloat = 14
    }
    
    // MARK: Properties
    private let presenter: EntityDetailsPresenterProtocol

    // MARK: UIProperties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIConstants.titleLabelFontSize, weight: .semibold)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIConstants.descriptionLabelFontSize, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .justified
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()

    private let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()

    // MARK: Init
    init(presenter: EntityDetailsPresenterProtocol) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func initialize() {
        view.backgroundColor = .white

        view.addSubview(titleLabel)

        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: UIConstants.titleLabelTopOffset).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true

        view.addSubview(descriptionLabel)

        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: UIConstants.textLabelTopOffset).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.contentInset).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.contentInset).isActive = true
    }

    // MARK: Private methods
    private func addImage(image: UIImage) {
        imageView.image = image
        view.addSubview(imageView)

        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    // MARK: Public methods
    func update(entity: MetaObject<Entity>) {
        titleLabel.text = entity.title
        descriptionLabel.text = entity.data?.text
        if let image = entity.image {
            addImage(image: image)
        }
    }

}

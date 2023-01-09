//
//  AnnotationInfoView.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 11.12.2022.
//

import UIKit

// MARK: - AnnotationInfoDelegate
protocol AnnotationInfoDelegate: AnyObject {
    func openEntityDetails(id: UUID)
}

// MARK: - AnnotationInfoView
final class AnnotationInfoView: UIView {
    
    // MARK: UIConstants
    struct UIConstants {
        static let titleHorizontalInset: CGFloat = 24
        static let imageSize: CGFloat = 96
        static let infoButtonBottomOffset: CGFloat = 24
        static let descriptionLabelFontSize: CGFloat = 14
    }
    
    // MARK: UIProperties
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: UIConstants.descriptionLabelFontSize, weight: .regular)
        label.contentMode = .topLeft
        label.numberOfLines = 6
        label.lineBreakMode = .byCharWrapping
        return label
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .gray
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("common.more", comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .Common.blueButton
        button.layer.cornerRadius = Constants.buttonRadius
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: Properties
    weak var delegate: AnnotationInfoDelegate?
    private var entityId: UUID?

    // MARK: Init
    init() {
        super.init(frame: .zero)
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private Methods
    private func initialize() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        
        addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.contentInset).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.contentInset).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: UIConstants.imageSize).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: UIConstants.imageSize).isActive = true
        
        addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.contentInset).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Constants.contentInset).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -UIConstants.titleHorizontalInset).isActive = true
        
        addSubview(infoButton)
        infoButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -UIConstants.infoButtonBottomOffset).isActive = true
        infoButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight).isActive = true
        infoButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.contentInset).isActive = true
        infoButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.contentInset).isActive = true
    }
    
    @objc private func infoButtonTapped() {
        guard let entityId else { return }
        delegate?.openEntityDetails(id: entityId)
    }

    // MARK: Public Methods
    func configurate(entity: MetaObject<Entity>) {
        entityId = entity.id
        descriptionLabel.text = entity.data?.text
        if let image = entity.image {
            imageView.image = image
            imageView.setNeedsDisplay()
        } else {
            imageView.image = UIImage.Common.locationPlaceholder
        }
    }

}

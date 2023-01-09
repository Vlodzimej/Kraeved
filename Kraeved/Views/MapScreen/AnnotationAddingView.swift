//
//  AnnotationAddingView.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 25.12.2022.
//

import UIKit
import KraevedKit
import MapKit

// MARK: - AnnotationAddingMode
enum AnnotationAddingMode {
    case location
    case type
    case name
    case description
}

// MARK: - AnnotationAddingViewDelegate
protocol AnnotationAddingViewDelegate: AnyObject {
    func addAnnotation(title: String, description: String)
}

// MARK: - AnnotationAddingViewProtocol
protocol AnnotationAddingViewProtocol: AnyObject {
    func update(mode: AnnotationAddingMode)
}

// MARK: - AnnotationAddingView
final class AnnotationAddingView: UIView, AnnotationAddingViewProtocol {

    // MARK: UIConstants
    struct UIConstants {
        static let fontSize: CGFloat = 16
        static let locationLabelTopOffset: CGFloat = 64
        static let coordsTextField: CGFloat = 14
        static let descriptionTextInset: CGFloat = 8
        static let nameLabelFontSize: CGFloat = 12
        static let descriptionLabelFontSize: CGFloat = 12
        static let nextButtonInset: CGFloat = 10
        static let nextButtonFontSize: CGFloat = 18
        static let nameTextFieldTopOffset: CGFloat = 48
        static let descriptionTextTopOffset: CGFloat = 48
        static let descriptionTextHeight: CGFloat = 112
        static let desctiptionTextRadius: CGFloat = 8
        static let nameLabelTopOffset: CGFloat = 8
        static let descriptionLabelTopOffset: CGFloat = 8
    }
    
    // MARK: Properties
    private var mode: AnnotationAddingMode?
    weak var delegate: AnnotationAddingViewDelegate?
    
    private let typePickerAdapter = AnnotationTypePickerAdapter()

    // MARK: UIProperties
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("mapScreen.selectCoords", comment: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: UIConstants.fontSize, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var coordsTextField: KTextField = {
        let textField = KTextField()
        textField.placeholder = NSLocalizedString("mapScreen.coordinates", comment: "")
        textField.font = UIFont.systemFont(ofSize: UIConstants.coordsTextField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .gray
        textField.textAlignment = .center
        return textField
    }()

    private lazy var nameTextField: KTextField = {
        let textField = KTextField()
        textField.placeholder = NSLocalizedString("mapScreen.newLocation", comment: "")
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: UIConstants.fontSize, weight: .regular)
        textField.textColor = .gray
        textField.delegate = self
        textField.addTarget(self, action: #selector(nameTextFieldDidChange), for: .editingChanged)
        return textField
    }()

    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: UIConstants.fontSize, weight: .regular)
        textView.layer.cornerRadius = UIConstants.desctiptionTextRadius
        textView.textColor = .gray
        textView.textContainerInset = UIEdgeInsets(top: UIConstants.descriptionTextInset, left: UIConstants.descriptionTextInset, bottom: 0, right: 0)
        textView.isHidden = true
        return textView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("mapScreen.enterNewLocationName", comment: "")
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: UIConstants.nameLabelFontSize, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("mapScreen.enterNewLocationDescription", comment: "")
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: UIConstants.descriptionLabelFontSize, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("common.next", comment: ""), for: .normal)
        button.setTitleColor(UIColor.Common.greenMain, for: .normal)
        button.setTitleColor(UIColor.gray, for: .disabled)
        button.tintColor = UIColor.Common.greenMain
        button.setImage(UIImage.Common.next, for: .normal)
        button.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: UIConstants.nextButtonInset, bottom: 0, right: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: UIConstants.nextButtonFontSize)
        button.isEnabled = false
        button.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var typePickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.isHidden = true
        return picker
    }()
    
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
        
        typePickerAdapter.configurate(pickerView: typePickerView)
        
        // TODO: Необходимо провести рефакторинг
        
        addSubview(locationLabel)
        locationLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: UIConstants.locationLabelTopOffset).isActive = true
        locationLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        addSubview(coordsTextField)
        coordsTextField.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: Constants.contentInset).isActive = true
        coordsTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.contentInset).isActive = true
        coordsTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.contentInset).isActive = true
        
        addSubview(typePickerView)
        typePickerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        typePickerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.contentInset).isActive = true
        typePickerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.contentInset).isActive = true

        addSubview(nameTextField)
        nameTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: UIConstants.nameTextFieldTopOffset).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.contentInset).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.contentInset).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: Constants.buttonHeight).isActive = true
        
        addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: UIConstants.nameLabelTopOffset).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

        addSubview(descriptionTextView)
        descriptionTextView.topAnchor.constraint(equalTo: self.topAnchor, constant: UIConstants.descriptionTextTopOffset).isActive = true
        descriptionTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.contentInset).isActive = true
        descriptionTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.contentInset).isActive = true
        descriptionTextView.heightAnchor.constraint(equalToConstant: UIConstants.descriptionTextHeight).isActive = true
        
        addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: UIConstants.descriptionLabelTopOffset).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        addSubview(nextButton)
        nextButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.contentInset).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight).isActive = true
        
        update(mode: .location)
    }
    
    @objc private func nextButtonTapped(_ sender: UIButton) {
        guard let mode else { return }
        switch mode {
            case .location:
                update(mode: .type)
            case .type:
                update(mode: .name)
            case .name:
                update(mode: .description)
            case .description:
                done()
        }
    }
    
    @objc private func nameTextFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        nextButton.isEnabled = text.count > 2
    }
    
    // MARK: Public Methods
    func update(mode: AnnotationAddingMode) {
        // TODO: Необходимо провести рефакторинг
        self.mode = mode
        
        switch mode {
            case .location:
                locationLabel.isHidden = false
                nameTextField.isHidden = true
                nameLabel.isHidden = true
                nextButton.isEnabled = false
                descriptionTextView.isHidden = true
                descriptionLabel.isHidden = true
                coordsTextField.isHidden = false
                coordsTextField.text = ""
            case .type:
                locationLabel.isHidden = true
                typePickerView.isHidden = false
                coordsTextField.isHidden = true
            case .name:
                typePickerView.isHidden = true
                nameTextField.isHidden = false
                nameLabel.isHidden = false
                nextButton.isEnabled = false
            case .description:
                nameTextField.isHidden = true
                nameLabel.isHidden = true
                descriptionTextView.isHidden = false
                descriptionLabel.isHidden = false
                nextButton.isEnabled = true
        }
    }
    
    func reset() {
        update(mode: .location)
    }
    
    func done() {
        delegate?.addAnnotation(title: nameTextField.text ?? "", description: descriptionTextView.text)
    }
}

// MARK: - UITextFieldDelegate
extension AnnotationAddingView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
}

// MARK: - MapScreenModuleOutput
extension AnnotationAddingView: MapScreenModuleOutput {
    func locationDidSelect(annotation: MKAnnotation) {
        nextButton.isEnabled = true
        coordsTextField.text = "\(annotation.coordinate.latitude), \(annotation.coordinate.longitude)"
    }
}

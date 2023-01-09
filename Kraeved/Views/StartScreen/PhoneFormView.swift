//
//  PhoneFormView.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 04.01.2023.
//

import UIKit
import KraevedKit

// MARK: - PhoneFormViewDelegate
protocol PhoneFormViewDelegate: AnyObject {
    func sendPhone(_ phone: String)
}

// MARK: - PhoneFormView
final class PhoneFormView: UIView {
    
    // MARK: UIConstants
    struct UIConstants {
        static let fontSize: CGFloat = 20
    }
    
    weak var delegate: PhoneFormViewDelegate?
    
    // MARK: UIProperties
    private lazy var formStack: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.addArrangedSubview(phoneLabel)
        stackView.addArrangedSubview(phoneField)
        stackView.addArrangedSubview(doneButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = NSLocalizedString("profile.enterPhone", comment: "")
        return label
    }()
    
    private lazy var phoneField: KTextField = {
        let textField = KTextField()
        textField.placeholder = Constants.phoneMask
        textField.font = UIFont.systemFont(ofSize: UIConstants.fontSize)
        textField.textAlignment = .center
        textField.delegate = self
        return textField
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("common.signIn", comment: ""), for: .normal)
        button.setTitleColor(.Common.greenMain, for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.isEnabled = false
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
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
        
        addSubview(formStack)
        formStack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        formStack.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        formStack.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        formStack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    @objc private func doneButtonTapped() {
        guard let text = phoneField.text else { return }
        let phone = text.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        delegate?.sendPhone(phone)
    }
    
    // MARK: Public Methods
    func viewDidAppear() {
        phoneField.becomeFirstResponder()
    }
}

// MARK: - UITextFieldDelegate
extension PhoneFormView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = formatPhoneNumber(with: Constants.phoneMask, phone: newString)
        
        if let textLength = textField.text?.count, textLength == 15 {
            doneButton.isEnabled = true
        } else {
            doneButton.isEnabled = false
        }
        
        return false
    }
}

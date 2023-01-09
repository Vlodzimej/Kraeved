//
//  CodeFormView.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 04.01.2023.
//

import UIKit
import KraevedKit

// MARK: - CodeFormViewDelegate
protocol CodeFormViewDelegate: AnyObject {
    func sendCode(_ code: String)
}

// MARK: - CodeFormView
final class CodeFormView: UIView {
    
    // MARK: UIConstants
    struct UIConstants {
        static let codeFieldHeight: CGFloat = 64
        static let fontSize: CGFloat = 20
    }
    
    weak var delegate: CodeFormViewDelegate?
    
    // MARK: UIProperties
    private let codeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Введите код из СМС"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var codeField: KTextField = {
        let textField = KTextField()
        textField.font = UIFont.systemFont(ofSize: UIConstants.fontSize)
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(codeFieldDidChange), for: .editingChanged)
        return textField
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
        
        addSubview(codeLabel)
        codeLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        codeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        codeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        addSubview(codeField)
        codeField.topAnchor.constraint(equalTo: codeLabel.bottomAnchor, constant: Constants.contentInset).isActive = true
        codeField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        codeField.widthAnchor.constraint(equalToConstant: UIConstants.codeFieldHeight).isActive = true
    }
    
    @objc private func codeFieldDidChange(textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count == 4 {
            delegate?.sendCode(text)
        }
    }
    
    // MARK: Public Methods
    func viewDidAppear() {
        codeField.becomeFirstResponder()
    }
}

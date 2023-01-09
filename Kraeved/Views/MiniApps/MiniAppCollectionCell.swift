//
//  MiniAppCollectionCell.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 05.01.2023.
//

import UIKit

final class MiniAppCollectionCell: UICollectionViewCell {
    
    // MARK: UIConstants
    struct UIConstants {
        static let titleInset: CGFloat = 8
        static let titleFontSize: CGFloat = 14
        static let titleTopOffset: CGFloat = 8
        static let imageMargin: CGFloat = 24
        static let containerViewBottomOffset: CGFloat = 64
    }
    
    // MARK: UIProperties
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = Constants.mainTableElementRadius
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private Methods
    private func initialize() {
        containerView.backgroundColor = generateRandomPastelColor(withMixedColor: UIColor.black)
        
        containerView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: UIConstants.imageMargin).isActive = true
        imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -UIConstants.imageMargin).isActive = true
        imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -UIConstants.imageMargin).isActive = true
        imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: UIConstants.imageMargin).isActive = true
        
        addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -UIConstants.containerViewBottomOffset).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        
        addSubview(titleLabel)
        titleLabel.topAnchor.constraint(greaterThanOrEqualTo: containerView.bottomAnchor, constant: UIConstants.titleTopOffset).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    // MARK: Public Methods
    func configurate(viewModel: MiniAppViewModel) {
        if let color = viewModel.backgroundColor {
            containerView.backgroundColor = color
        } else {
            containerView.backgroundColor = generateRandomPastelColor(withMixedColor: UIColor.black)
        }
        
        if let image = viewModel.image {
            imageView.image = image
            imageView.isHidden = false
        } else {
            imageView.isHidden = true
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.8
        paragraphStyle.alignment = .center
        
        let  titleAttributedString = NSMutableAttributedString(string: viewModel.title, attributes:
                                                                [.font: UIFont.systemFont(ofSize: UIConstants.titleFontSize, weight: .regular), .foregroundColor: UIColor.black, .paragraphStyle: paragraphStyle])
        titleLabel.attributedText = titleAttributedString
    }
}

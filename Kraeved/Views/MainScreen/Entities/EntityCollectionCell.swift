//
//  EntitytCollectionCell.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 20.11.2022.
//

import UIKit

// MARK: - EntitytCollectionCell
final class EntityCollectionCell: CollectionCellWithShimmer {
    
    // MARK: UIConstants
    struct UIConstants {
        static let titleInset: CGFloat = 8
        static let titleLabelFontSize: CGFloat = 14
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
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = Constants.mainTableElementRadius
        return imageView
    }()
    
    private lazy var gradientMaskLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.frame = contentView.bounds
        layer.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
        layer.locations = [0, 0.85]
        return layer
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
        imageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        
        containerView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(greaterThanOrEqualTo: containerView.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -UIConstants.titleInset).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: UIConstants.titleInset).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -UIConstants.titleInset).isActive = true
        
        addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
    }
    
    // MARK: Public Methods
    func configurate(title: String?, image: UIImage?, hasOverlay: Bool = false) {
        
        if let image = image {
            imageView.image = image
            imageView.isHidden = false
            imageView.layer.mask = hasOverlay ? gradientMaskLayer : nil
            
            let averageColor = image.averageColor()
            containerView.backgroundColor = averageColor.mix(with: UIColor.black, amount: 0.65)
        } else {
            imageView.isHidden = true
        }
        
        if let title = title {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 0.8
            
            let  titleAttributedString = NSMutableAttributedString(string: title, attributes:
                                                                    [.font: UIFont.systemFont(ofSize: UIConstants.titleLabelFontSize, weight: .regular), .foregroundColor: UIColor.white, .paragraphStyle: paragraphStyle])
            titleLabel.attributedText = titleAttributedString
            titleLabel.isHidden = false
        } else {
            titleLabel.isHidden = true
        }
    }
}

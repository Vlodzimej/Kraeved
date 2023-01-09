//
//  ActivityIndicatorView.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 18.12.2022.
//

import UIKit

// MARK: - ActivityIndicatorView
final class ActivityIndicatorView: UIView {

    // MARK: UIConstants
    struct UIConstants {
        static let size: CGFloat = 64
    }

    // MARK: UIProperties
    private let mainView: UIView = {
        let view = UIView()
        return view
    }()

    private let squareLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.lightGray.cgColor
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        return layer
    }()

    // MARK: Init
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private Methods
    private func initialize() {
        squareLayer.frame = CGRect(x: 0, y: 0, width: UIConstants.size, height: UIConstants.size)

        let rotationAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: Double.pi * 2)
        rotationAnimation.duration = 1
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = Float.greatestFiniteMagnitude

        layer.addSublayer(squareLayer)

        CATransaction.begin()
        squareLayer.add(rotationAnimation, forKey: "rotationAnimation")
        CATransaction.commit()
    }
}

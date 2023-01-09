//
//  CollectionCellWithShimmer.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 25.11.2022.
//

import UIKit

// MARK: - CollectionCellWithShimmer
class CollectionCellWithShimmer: UICollectionViewCell {

    private let gradientColorOne = UIColor.MainScreen.shimmerColorFirst.cgColor
    private let gradientColorTwo = UIColor.MainScreen.shimmerColorSecond.cgColor

    func startAnimating() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [gradientColorOne, gradientColorTwo, gradientColorOne]
        gradientLayer.locations = [0.0, 0.5, 1.0]

        layer.addSublayer(gradientLayer)
        layer.masksToBounds = true
        layer.cornerRadius = Constants.mainTableElementRadius

        let animation = CABasicAnimation(keyPath: "locations")
        animation.speed = 0.3
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: animation.keyPath)
    }
}

//
//  MiniAppsAdapter.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 05.01.2023.
//

import UIKit

// MARK: - MiniAppViewModel
struct MiniAppViewModel {
    let title: String
    let image: UIImage?
    let backgroundColor: UIColor?
}

// MARK: - MiniaAppCollectionAdapterDelegate
protocol MiniaAppCollectionAdapterDelegate: AnyObject {
    func showMessage()
    func openGenealogy()
}

// MARK: - MiniAppCollectionAdapterProtocol
protocol MiniAppCollectionAdapterProtocol: AnyObject, UICollectionViewDelegate {
    var delegate: MiniaAppCollectionAdapterDelegate? { get set }
    
    func setup(collectionView: UICollectionView)
}

// MARK: - MiniAppCollectionAdapter
final class MiniAppCollectionAdapter: NSObject, MiniAppCollectionAdapterProtocol {
    
    // MARK: UIConstants
    struct UIConstants {
        static let extraHeight: CGFloat = 64
    }
    
    // MARK: Properties
    private var collectionView: UICollectionView?
    weak var delegate: MiniaAppCollectionAdapterDelegate?
    
    private let items: [MiniAppViewModel] = [
        .init(title: NSLocalizedString("miniapps.notes", comment: ""), image: UIImage.MiniApps.notes, backgroundColor: UIColor.MiniApps.notes),
        .init(title: NSLocalizedString("miniapps.genealogy", comment: ""), image: UIImage.MiniApps.genealogy, backgroundColor: UIColor.MiniApps.genealogy),
        .init(title: NSLocalizedString("miniapps.shelter", comment: ""), image: UIImage.MiniApps.shelter, backgroundColor: UIColor.MiniApps.shelter),
        .init(title: NSLocalizedString("miniapps.education", comment: ""), image: UIImage.MiniApps.education, backgroundColor: UIColor.MiniApps.education)
    ]
    
    // MARK: Public Methods
    func setup(collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MiniAppCollectionCell.self, forCellWithReuseIdentifier: "MiniAppCollectionViewCell")
        self.collectionView = collectionView
    }
}

// MARK: - UICollectionViewDataSource
extension MiniAppCollectionAdapter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MiniAppCollectionViewCell", for: indexPath) as? MiniAppCollectionCell else {
            return UICollectionViewCell()
        }
        
        guard let item = items[safeIndex: indexPath.row] else {
            return cell
        }
        
        cell.configurate(viewModel: item)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: Constants.contentInset, left: Constants.contentInset, bottom: Constants.contentInset, right: Constants.contentInset)
    }
}

// MARK: - UICollectionViewDelegate
extension MiniAppCollectionAdapter: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            delegate?.openGenealogy()
        } else {
            delegate?.showMessage()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MiniAppCollectionAdapter: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let numberOfItemsPerRow = 4.0
        let itemDimension = floor(width / numberOfItemsPerRow)
        return CGSize(width: itemDimension, height: itemDimension + UIConstants.extraHeight)
    }
}

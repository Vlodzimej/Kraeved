//
//  EntityCellView.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 20.11.2022.
//

import UIKit

protocol EntityCellDelegate: AnyObject {
    func showDetails(id: UUID)
}

protocol EntityCellViewProtocol {
    var delegate: EntityCellDelegate? { get set }
}

//MARK: - EntityCellView
class EntityCellView: UIView, EntityCellViewProtocol {
    
    //MARK: - Properties
    weak var delegate: EntityCellDelegate?
    
    private let items: [MainTableCellItem]
    private let type: EntityType
    
    //MARK: - UIProperties
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(EntitytCollectionCell.self, forCellWithReuseIdentifier: "HistoricalEventCollectionCell")
        return collectionView
    }()
    
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let itemsSpacing: CGFloat = 16
        layout.minimumLineSpacing = itemsSpacing
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    //MARK: - Init
    init(items: [MainTableCellItem], type: EntityType) {
        self.items = items
        self.type = type
        super.init(frame: .zero)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Methods
    private func initialize() {
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .clear
        
        addSubview(collectionView)
        collectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}

//MARK: - UICollectionViewDataSource
extension EntityCellView: UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count > 0 ? items.count : 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoricalEventCollectionCell", for: indexPath) as? EntitytCollectionCell else {
            return UICollectionViewCell()
        }
        guard let item = items[safeIndex: indexPath.item] else {
            cell.startAnimating()
            return cell
        }
        cell.configurate(title: item.title, image: item.image, hasOverlay: item.hasOverlay)
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension EntityCellView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let historicalEvent = items[indexPath.item]
        delegate?.showDetails(id: historicalEvent.id)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension EntityCellView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: Constants.contentInset, left: Constants.contentInset, bottom: Constants.contentInset, right: Constants.contentInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = getNumberOfItemsPerRow()
        let spacing: CGFloat = flowLayout.minimumInteritemSpacing
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)
        return CGSize(width: itemDimension, height: itemDimension)
    }
    
    private func getNumberOfItemsPerRow() -> CGFloat {
        switch type {
            case .historicalEvent:
                return 2.5
            case .location:
                return 2.5
            case .photo:
                return 1.4
        }
    }
}
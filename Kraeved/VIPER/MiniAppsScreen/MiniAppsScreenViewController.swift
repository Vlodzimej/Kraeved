//
//  MiniAppsScreenViewController.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 24.12.2022.
//

import UIKit

// MARK: - MiniAppsScreenViewProtocol
protocol MiniAppsScreenViewProtocol: AnyObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
}

// MARK: - MiniAppsScreenViewController
final class MiniAppsScreenViewController: BaseViewController, MiniAppsScreenViewProtocol {
    
    // MARK: Properties
    private let presenter: MiniAppsScreenPresenterProtocol
    
    private let adapter: MiniAppCollectionAdapterProtocol = MiniAppCollectionAdapter()

    // MARK: UIProperties
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: Constants.contentInset, left: Constants.contentInset, bottom: 0, right: Constants.contentInset)
        return collectionView
    }()
    
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        return layout
    }()

    // MARK: Init
    init(presenter: MiniAppsScreenPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("don't use storyboards!")
    }

    // MARK: VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        adapter.setup(collectionView: collectionView)
        adapter.delegate = presenter
        initialize()
        
    }

    private func initialize() {
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    // MARK: Private methods

    // MARK: Public methods

}

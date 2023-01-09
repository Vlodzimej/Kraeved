//
//  GenealogyViewController.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 06.01.2023.
//

import UIKit
import WebKit

// MARK: - GenealogyViewProtocol
protocol GenealogyViewProtocol: AnyObject {
}

// MARK: - GenealogyViewController
final class GenealogyViewController: BaseViewController, GenealogyViewProtocol {

    // MARK: Properties
    private let presenter: GenealogyPresenterProtocol
    
    // MARK: UIProperties
    private let webView: WKWebView = {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Init
    init(presenter: GenealogyPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("don't use storyboards!")
    }

    // MARK: VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    private func initialize() {
        view.addSubview(webView)
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        let url = URL(string: "https://kaluga-genealogia.ru")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }

    // MARK: Private methods

    // MARK: Public methods

}

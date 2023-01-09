import UIKit
import MapKit

// MARK: - MapScreenViewProtocol
protocol MapScreenViewProtocol: AnyObject {
    var mapView: MKMapView { get set }
    var annotationAddingView: AnnotationAddingView { get set }
    
    func showAnnotationInfo(entity: MetaObject<Entity>)
    func showAnnotationAdding()
    func showBottomPanel()
    func hideBottomPanel() 
}

// MARK: - MapScreenViewController
final class MapScreenViewController: BaseViewController, MapScreenViewProtocol {
    
    // MARK: UIConstants
    private struct UIConstants {
        static let addButtonSize: CGFloat = 64
        static let addButtonInset: CGFloat = 32
    }

    // MARK: Properties
    private let presenter: MapScreenPresenterProtocol

    private var isBottomPanelHidden = true
    private var bottomPanelAnchor: NSLayoutConstraint?
    
    private lazy var bottomPanelHeight = {
        view.bounds.height / 4
    }()

    // MARK: UIProperties
    var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = UIConstants.addButtonSize / 2
        button.setImage(.Common.plus, for: .normal)
        button.backgroundColor = .Common.blueMain
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    private let bottomPanelView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Common.greenAlphaBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.layer.borderColor = UIColor.MapScreen.bottomPanelBorder.cgColor
        view.layer.borderWidth = 1
        return view
    }()

    private let annotationInfoView = AnnotationInfoView()
    var annotationAddingView = AnnotationAddingView()

    // MARK: Init
    init(presenter: MapScreenPresenterProtocol) {
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
        presenter.viewDidLoad()
        
        mapView.delegate = presenter
        annotationInfoView.delegate = presenter
        annotationAddingView.delegate = presenter
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChangesVisibility(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChangesVisibility(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
    }

    private func initialize() {
        navigationController?.setNavigationBarHidden(true, animated: false)

        view.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        view.addSubview(bottomPanelView)
        bottomPanelView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomPanelView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomPanelAnchor = bottomPanelView.heightAnchor.constraint(equalToConstant: 0)
        bottomPanelAnchor?.isActive = true
        bottomPanelView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        view.addSubview(addButton)
        addButton.bottomAnchor.constraint(equalTo: bottomPanelView.topAnchor, constant: -UIConstants.addButtonInset).isActive = true
        addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.addButtonInset).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: UIConstants.addButtonSize).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: UIConstants.addButtonSize).isActive = true

        bottomPanelView.addSubview(annotationInfoView)
        annotationInfoView.topAnchor.constraint(equalTo: bottomPanelView.topAnchor).isActive = true
        annotationInfoView.trailingAnchor.constraint(equalTo: bottomPanelView.trailingAnchor).isActive = true
        annotationInfoView.leadingAnchor.constraint(equalTo: bottomPanelView.leadingAnchor).isActive = true
        annotationInfoView.bottomAnchor.constraint(equalTo: bottomPanelView.bottomAnchor).isActive = true
        
        bottomPanelView.addSubview(annotationAddingView)
        annotationAddingView.topAnchor.constraint(equalTo: bottomPanelView.topAnchor).isActive = true
        annotationAddingView.trailingAnchor.constraint(equalTo: bottomPanelView.trailingAnchor).isActive = true
        annotationAddingView.leadingAnchor.constraint(equalTo: bottomPanelView.leadingAnchor).isActive = true
        annotationAddingView.bottomAnchor.constraint(equalTo: bottomPanelView.bottomAnchor).isActive = true
    }

    @IBAction private func addButtonTapped(_ sender: UIButton) {
        if isBottomPanelHidden && !presenter.hasAuthorization {
            showLoginAlert()
            return
        }
        
        toggleBottomPanel()
        
        if isBottomPanelHidden && presenter.mode == .addingAnnotation {
            presenter.updateAnnotations()
        }
        
        presenter.mode = isBottomPanelHidden ? .researching : .addingAnnotation
        if presenter.mode == .addingAnnotation {
            showAnnotationAdding()
        }
    }

    private func toggleBottomPanel() {
        if isBottomPanelHidden {
            showBottomPanel()
        } else {
            hideBottomPanel()
        }
    }

    func showBottomPanel() {
        addButton.setImage(UIImage.Common.xmark, for: .normal)
        addButton.backgroundColor = UIColor.MapScreen.closeButton
        bottomPanelAnchor?.constant = bottomPanelHeight
        isBottomPanelHidden = false
        
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.view.layoutSubviews()
        }
    }

    func hideBottomPanel() {
        addButton.setImage(UIImage.Common.plus, for: .normal)
        addButton.backgroundColor = .Common.blueMain
        bottomPanelAnchor?.constant = 0
        isBottomPanelHidden = true
        
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.view.layoutSubviews()
        }
        
        if presenter.mode == .addingAnnotation {
            presenter.removeNewAnnotation()
            mapView.selectedAnnotations = []
        }
        
        view.endEditing(true)
    }
    
    func showLoginAlert() {
        let alertViewController = UIAlertController(title: nil, message: NSLocalizedString("mapScreen.needSignIn", comment: ""), preferredStyle: .actionSheet)
        let loginAction = UIAlertAction(title: NSLocalizedString("common.signIn", comment: ""), style: .default) { [weak self] _ in
            self?.presenter.openLoginForm()
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("common.cancel", comment: ""), style: .cancel)
        alertViewController.addAction(loginAction)
        alertViewController.addAction(cancelAction)
        navigationController?.present(alertViewController, animated: true)
    }
    
    @objc private func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        switch presenter.mode {
            case .addingAnnotation:
                let location = gestureRecognizer.location(in: mapView)
                presenter.createAnnotation(by: location)
            default: break
        }
    }
    
    @objc private func keyboardWillChangesVisibility(notification: NSNotification) {
        guard !isBottomPanelHidden else { return }
        var keyboardSize: CGSize?
        
        if let info = notification.userInfo {
            let frameEndUserInfoKey = UIResponder.keyboardFrameEndUserInfoKey
            if let keyboardFrame = info[frameEndUserInfoKey] as? CGRect {
                
                let screenSize = UIScreen.main.bounds
                let intersectRect = keyboardFrame.intersection(screenSize)
                
                if intersectRect.isNull {
                    keyboardSize = CGSize(width: screenSize.size.width, height: 0)
                } else {
                    keyboardSize = intersectRect.size
                }
                
                guard let keyboardHeight = keyboardSize?.height else { return }
                let navigationBarHeight = keyboardHeight > 0 ? navigationController?.navigationBar.frame.height ?? 0 : 0
                bottomPanelAnchor?.constant = bottomPanelHeight + keyboardHeight - navigationBarHeight
                UIView.animate(withDuration: 0.25) { [weak self] in
                    guard let self = self else { return }
                    self.view.layoutSubviews()
                }
            }
        }
    }

    // MARK: Public Methods
    func showAnnotationInfo(entity: MetaObject<Entity>) {
        annotationInfoView.isHidden = false
        annotationAddingView.isHidden = true
        
        showBottomPanel()
        annotationInfoView.configurate(entity: entity)
    }
    
    func showAnnotationAdding() {
        annotationInfoView.isHidden = true
        annotationAddingView.isHidden = false
    
        annotationAddingView.reset()
    }
}

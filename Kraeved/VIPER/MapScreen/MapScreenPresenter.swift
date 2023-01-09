import UIKit
import MapKit

protocol MapScreenModuleOutput: AnyObject {
    func locationDidSelect(annotation: MKAnnotation)
}

// MARK: - MapScreenPresenterProtocol
protocol MapScreenPresenterProtocol: AnyObject, MKMapViewDelegate, AnnotationInfoDelegate, AnnotationAddingViewDelegate, StartScreenModuleOutput {
    var mode: MapScreenMode { get set }
    var hasAuthorization: Bool { get }

    func viewDidLoad()
    func addAnnotations(annotations: [Annotation])
    func createAnnotation(by location: CGPoint)
    func removeNewAnnotation()
    func updateAnnotations()
    func openLoginForm()
}

// MARK: - MapScreenMode
enum MapScreenMode {
    case researching
    case addingAnnotation
}

// MARK: - MapScreenPresenter
final class MapScreenPresenter: NSObject, MapScreenPresenterProtocol {

    // MARK: Constants
    private struct Constants {
        static let startLocation = CLLocation(latitude: 54.51707774498945, longitude: 36.23049989395381)
    }
    // MARK: Properties
    weak var view: MapScreenViewProtocol?
    private let interactor: MapScreenInteractorProtocol
    private let router: MapScreenRouterProtocol
    private let locationManager = CLLocationManager()
    private var newAnnotation: MKAnnotation?
    
    private weak var output: MapScreenModuleOutput?

    var selectedAnnotation: MKPointAnnotation?
    var mode: MapScreenMode = .researching
    
    var hasAuthorization: Bool {
        interactor.hasAuthorization
    }

    // MARK: Init
    init(interactor: MapScreenInteractorProtocol, router: MapScreenRouterProtocol) {
        self.router = router
        self.interactor = interactor
    }

    func viewDidLoad() {
        guard let view = view else { return }

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        view.mapView.showsUserLocation = true

        let cameraCenter = Constants.startLocation
        let region = MKCoordinateRegion(center: cameraCenter.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        view.mapView.setRegion(region, animated: true)
        interactor.getAnnotations()
        
        output = view.annotationAddingView
    }

    func addAnnotations(annotations: [Annotation]) {
        view?.mapView.addAnnotations(annotations)
    }

    private func openAnnotation(annotation: Annotation) {
        interactor.getEntity(id: annotation.id) { [weak self] entity in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.view?.showAnnotationInfo(entity: entity)
            }
        }
    }

    func createAnnotation(by location: CGPoint) {
        guard let mapView = view?.mapView else { return }
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)

        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        selectedAnnotation = annotation
        mapView.addAnnotation(annotation)
    }
    
    func removeNewAnnotation() {
        guard let mapView = view?.mapView else { return }
        guard let annotation = selectedAnnotation else { return }
        mapView.removeAnnotation(annotation)
    }

    func updateAnnotations() {
        interactor.getAnnotations()
    }
    
    func openLoginForm() {
        router.openStartScreen(output: self)
    }
}

extension MapScreenPresenter: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let view = view, let annotation = annotation as? Annotation else { return nil }

        let markerView: MKMarkerAnnotationView

        if let dequeueView = view.mapView.dequeueReusableAnnotationView(withIdentifier: "locations") as? MKMarkerAnnotationView {
            dequeueView.annotation = annotation
            markerView = dequeueView
        } else {
            markerView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "locations")
            markerView.canShowCallout = true
            markerView.calloutOffset = CGPoint(x: -5, y: 5)
            markerView.leftCalloutAccessoryView = UIImageView(image: UIImage.Common.location)
        }
        return markerView
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {

    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? Annotation else { return }
        openAnnotation(annotation: annotation)
        mapView.setCenter(annotation.coordinate, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if mode == .researching {
            self.view?.hideBottomPanel()
        }
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        guard let output = output, let annotation = views.first?.annotation else { return }
        if mode == .addingAnnotation {
            output.locationDidSelect(annotation: annotation)
        }
    }
}

// MARK: - AnnotationAddingViewDelegate
extension MapScreenPresenter: AnnotationAddingViewDelegate {
    func addAnnotation(title: String, description: String) {
        guard let coordinate = selectedAnnotation?.coordinate else { return }
        let newAnnotation = Annotation(id: UUID(), coordinate: coordinate, title: title, subtitle: "", text: description)
        interactor.addAnnotation(newAnnotation) { [weak self] result in
            guard let self else { return }
            self.interactor.getAnnotations()
            DispatchQueue.main.async {
                self.view?.hideBottomPanel()
                self.mode = .researching
                if let title = result.title {
                    let localizedString = NSLocalizedString("mapScreen.locationAdded", comment: "")
                    let message = String(format: localizedString, title)
                    self.router.showAlertMessage(message)
                }
            }
        }
    }
}
// MARK: - AnnotationInfoDelegate
extension MapScreenPresenter: AnnotationInfoDelegate {
    func openEntityDetails(id: UUID) {
        router.openEntityDetails(id: id)
    }
}

// MARK: - StartScreenModuleOutput
extension MapScreenPresenter: StartScreenModuleOutput {
    func logged() {
        view?.showBottomPanel()
    }
}

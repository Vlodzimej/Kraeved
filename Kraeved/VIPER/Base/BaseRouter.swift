import UIKit

protocol BaseRouterProtocol {
    func openAnnotation(annotation: Annotation)
    func openEntityDetails(id: UUID)
    func openStartScreen(output: StartScreenModuleOutput?)
    func showAlertMessage(_ message: String)
    func showMessageScreen(_ message: String)
    func dismiss()
}

class BaseRouter<T>: BaseRouterProtocol where T: UIViewController {
    var viewController: T?

    func openAnnotation(annotation: Annotation) {
        let annotationVC = AnnotationScreenModuleBuilder.build(annotation: annotation)
        guard let viewController = viewController else { return }
        viewController.navigationController?.present(annotationVC, animated: true)
    }

    func openEntityDetails(id: UUID) {
        let entityDetailsVC = EntityDetailsModuleBuilder.build(id: id)
        guard let viewController = viewController else { return }
        viewController.navigationController?.pushViewController(entityDetailsVC, animated: true)
    }
    
    func openStartScreen(output: StartScreenModuleOutput?) {
        let startScreenViewController = StartScreenModuleBuilder.build(output: output)
        viewController?.navigationController?.present(startScreenViewController, animated: true)
    }
    
    func showAlertMessage(_ message: String) {
        let alertViewController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: NSLocalizedString("common.close", comment: ""), style: .default))
        viewController?.present(alertViewController, animated: true)
    }
    
    func showMessageScreen(_ message: String) {
        let messageViewController = MessageScreenModuleBuilder.build(messageText: message)
        viewController?.present(messageViewController, animated: true)
    }
    
    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}

//
//  BaseRouterMock.swift
//  KraevedTests
//
//  Created by Владимир Амелькин on 21.12.2022.
//

import Foundation
@testable import Kraeved

class BaseRouterMock: MainScreenRouterProtocol {

    var isAnnotationOpened: Bool = false
    var isEntityDetailsOpened: Bool = false
    var isStartScreenOpened: Bool = false
    var isAlertMessageShown: Bool = false
    var isMessageScreenShown: Bool = false
    var isDismissed: Bool = false

    func openAnnotation(annotation: Kraeved.Annotation) {
        isAnnotationOpened = true
    }

    func openEntityDetails(id: UUID) {
        isEntityDetailsOpened = true
    }
    
    func openStartScreen(output: Kraeved.StartScreenModuleOutput?) {
        isStartScreenOpened = true
    }
    
    func showAlertMessage(_ message: String) {
        isAlertMessageShown = true
    }
    
    func showMessageScreen(_ message: String) {
        isMessageScreenShown = true
    }
    
    func dismiss() {
        isDismissed = true
    }
    
}

//
//  MiniAppsScreenRouter.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 24.12.2022.
//

import Foundation

protocol MiniAppsScreenRouterProtocol: BaseRouterProtocol {
    func openGenealogy() 
}

final class MiniAppsScreenRouter: BaseRouter<MiniAppsScreenViewController>, MiniAppsScreenRouterProtocol {
    func openGenealogy() {
        let genealogyViewController = GenealogyModuleBuilder.build()
        viewController?.navigationController?.pushViewController(genealogyViewController, animated: true)
    }
}

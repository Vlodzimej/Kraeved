//
//  AnnotationManager.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 09.11.2022.
//

import MapKit

protocol AnnotationManagerProtocol {
    func getAnnotations() async throws -> [Annotation]
    func getTransport() async throws -> [Transport]
}

class AnnotationManager {
    
    static let shared = AnnotationManager()
    
    private let apiManager: APIManager
    
    private init(apiManager: APIManager = APIManager.shared) {
        self.apiManager = apiManager
    }
    
    func getAnnotations() async throws -> [Annotation] {
//        guard let url =  URL(string: "https://my-json-server.typicode.com/vlodzimej/kraeved/annotations") else { return [] }
//        let request = URLRequest(url: url)
        // Здесь временно хардкод
        let factory = AnnotationFactory()
        let annotations = [
            factory.makeBuilding(id: 1, coordinate: CLLocationCoordinate2D(latitude: 54.513974779803796, longitude: 36.263196462037726), title: "Кинотеатр «Центральный»", subtype: .culture),
            factory.makeBuilding(id: 2, coordinate: CLLocationCoordinate2D(latitude: 54.51709314831746, longitude: 36.246505391757296), title: "ТРК «XXI Век»", subtype: .moll),
            factory.makeNature(id: 3, coordinate: CLLocationCoordinate2D(latitude: 54.52259638006321, longitude: 36.207656513989434), title: "Сосновый бор", subtype: .forest)
        ]
        
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return annotations
    }
    
    func getTransport() async throws -> [Transport] {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return [
            .init(name: "Маршрут 1", route: [1, 2]),
            .init(name: "Маршрут 2", route: [3, 1, 2]),
            .init(name: "Маршрут 3", route: [2, 3])
        ]
    }
}
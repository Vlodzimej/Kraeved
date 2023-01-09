//
//  Annotation.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 29.06.2022.
//

import Foundation
import MapKit

final class Annotation: NSObject, MKAnnotation {

    var id: UUID

    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var text: String?

    let startDate: Date?

    init(id: UUID, coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, startDate: Date? = nil, text: String? = nil) {
        self.id = id
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.startDate = startDate
        self.text = text
    }
    
    init(_ entity: MetaObject<Entity>) {
        self.id = entity.id
        self.coordinate = CLLocationCoordinate2D(latitude: entity.data?.latitude ?? 0, longitude: entity.data?.longitude ?? 0)
        self.title = entity.title
        self.subtitle = ""
        self.startDate = nil
        self.text = entity.data?.text
    }
    
    func convertToEntity() -> MetaObject<Entity>? {
        var entity = MetaObject<Entity>(id: id, title: title, image: nil)
        entity.data = Entity(imageUrl: nil, text: text, typeId: EntityType.location.id, longitude: coordinate.longitude, latitude: coordinate.latitude)
        return entity
    }
}

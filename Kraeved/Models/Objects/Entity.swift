//
//  Entity.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 21.11.2022.
//
import Foundation

enum EntityType: String, CaseIterable {
    case historicalEvent    = "A58AA211-D7A0-461A-8D0A-7F90DB0BD06B"
    case location           = "FD16F472-2230-4FD0-A532-44854F12D749"
    case photo              = "9E411FA3-5761-43F7-ACEF-F4BB47692406"
    
    var id: UUID {
        guard let uuid = UUID(uuidString: self.rawValue) else {
            debugPrint("Can't create EntityType UUID")
            return UUID()
        }
        return uuid
    }
}

struct Entity: Codable, Equatable {
    static let metaTypeId = MetaType.entity.id
    
    var imageUrl: String?
    var text: String?
    var typeId: UUID?
    var longitude: CLongDouble?
    var latitude: CLongDouble?
    
    static func == (lhs: Entity, rhs: Entity) -> Bool {
        if lhs.imageUrl != lhs.imageUrl {
            return false
        }
        
        if lhs.text != rhs.text {
            return false
        }
        
        if lhs.typeId != rhs.typeId {
            return false
        }
        
        if lhs.longitude != rhs.longitude {
            return false
        }
        
        if lhs.latitude != rhs.latitude {
            return false
        }
        
        return true
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(text, forKey: .text)
        try container.encode(typeId, forKey: .typeId)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(latitude, forKey: .latitude)
    }
    
    enum CodingKeys: String, CodingKey {
        case imageUrl
        case text
        case typeId
        case longitude
        case latitude
    }
}

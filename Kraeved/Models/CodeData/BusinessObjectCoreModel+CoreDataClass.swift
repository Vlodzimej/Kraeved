//
//  BusinessObjectCoreModel+CoreDataClass.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 28.11.2022.
//
//

import Foundation
import CoreData

public final class BusinessObjectCoreModel: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.shared.entityForName(entityName: "BusinessObjectCoreModel"), insertInto: CoreDataManager.shared.managedObjectContext)
    }
}

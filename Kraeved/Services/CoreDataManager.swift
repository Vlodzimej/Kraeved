//
//  CoreDataManager.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 28.11.2022.
//

import UIKit
import Foundation
import CoreData

// MARK: - CoreDataManagerProtocol
protocol CoreDataManagerProtocol {
    var managedObjectContext: NSManagedObjectContext { get set }

    func saveContext ()
    func find(entityName: String, predicates: [NSPredicate]) -> [NSFetchRequestResult]
}

// MARK: - CoreDataManager
final class CoreDataManager: CoreDataManagerProtocol {

    static let shared = CoreDataManager()
    
    // MARK: Constants
    struct Contants {
        static let modelName = "Kraeved"
    }

    // MARK: Properties
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: Contants.modelName, withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError()
        }
        return model
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(Contants.modelName + ".sqlite")
        let description = NSPersistentStoreDescription()
        description.shouldInferMappingModelAutomatically = true
        description.shouldMigrateStoreAutomatically = true
        description.url = url
        description.type = NSSQLiteStoreType
        description.shouldAddStoreAsynchronously = false
        coordinator.addPersistentStore(with: description) { description, error in
            if let error = error {
                assertionFailure("Failed to add persistent store: \(error)")
            }
        }
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.automaticallyMergesChangesFromParent = true
        managedObjectContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: Public Methods
    func entityForName(entityName: String) -> NSEntityDescription {
        NSEntityDescription.entity(forEntityName: entityName, in: self.managedObjectContext)!
    }

    func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

    func find(entityName: String, predicates: [NSPredicate]) -> [NSFetchRequestResult] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        let fetchResult = try? managedObjectContext.fetch(fetchRequest)
        guard let fetchResult = fetchResult else {
            fatalError()
        }
        return fetchResult
    }

    func removeAllEntities(entityName: String) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try managedObjectContext.execute(deleteRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
}

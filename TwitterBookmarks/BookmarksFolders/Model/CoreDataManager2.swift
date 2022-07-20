//
//  CoreDataManager2.swift
//  TwitterBookmarks
//
//  Created by mac on 18/07/2022.
//

import Foundation
import CoreData

class CoreDataManager2{
    let managedObjectModelName: String
    let databasePath: URL

    init(managedObjectModelName: String, databasePath: URL) {
        self.managedObjectModelName = managedObjectModelName
        self.databasePath = databasePath
    }

    // MARK: Managed Object Contexts

    private var sharedContext: NSManagedObjectContext?

    func getSharedManagedObjectContext() throws -> NSManagedObjectContext {
        if let sharedContext = self.sharedContext {
            return sharedContext
        }

        let context = try self.createManagedObjectContext()
        self.sharedContext = context
        return context
    }

    func createManagedObjectContext() throws -> NSManagedObjectContext {
        let storeCoordinator = try self.getPersistentStoreCoordinator()

        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = storeCoordinator
        managedObjectContext.mergePolicy = NSMergePolicy(merge: NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType)

        return managedObjectContext
    }

    // MARK: Creating Entities

    func createEntityInSharedContext<EntityType>(_ entityName: String) throws -> EntityType {
        let context = try self.getSharedManagedObjectContext()
        return try self.createEntity(entityName, context: context)
    }

    func createEntity<EntityType>(_ entityName: String, context: NSManagedObjectContext) throws -> EntityType {
        let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)

        guard let expectedEntity = entity as? EntityType else {
            throw self.errorWithMessage("ACSwiftCoreData: Entity for name \(entityName) does not match class \(EntityType.self).")
        }

        return expectedEntity
    }

    // MARK: Saving Entity

    func saveEntity(_ entity: NSManagedObject) throws {
        guard let context = entity.managedObjectContext else {
            throw errorWithMessage("ACSwiftCoreData: Cannot save Entity. ManagedObjectContext is missing.")
        }

        if context.hasChanges {
            try context.save()
        }
    }

    // MARK: Delete Entity

    func deleteEntity(_ entity: NSManagedObject) throws {
        guard let context = entity.managedObjectContext else {
            throw errorWithMessage("ACSwiftCoreData: Cannot delete Entity. ManagedObjectContext is missing.")
        }

        context.delete(entity)
        try context.save()
    }

    // MARK: Fetch Requests

    func fetchEntitiesInSharedContext<EntityType: AnyObject>(_ entityName: String, predicate: NSPredicate?) -> [EntityType] {
        guard let context = try? self.getSharedManagedObjectContext() else {
            return [EntityType]()
        }

        return self .fetchEntities(entityName, context: context, predicate: predicate)
    }

    func fetchEntities<EntityType: AnyObject>(_ entityName: String, context: NSManagedObjectContext, predicate: NSPredicate?) -> [EntityType] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate

        let results = try? context.fetch(fetchRequest)

        guard let resultEntitys = results as? [EntityType] else {
            return [EntityType]()
        }

        return resultEntitys
    }

    // MARK: Technical Details

    private var storeCoordinator: NSPersistentStoreCoordinator?

    private func getPersistentStoreCoordinator() throws -> NSPersistentStoreCoordinator {
        if let storeCoordinator = self.storeCoordinator {
            return storeCoordinator
        }

        let model = try self.getManagedObjectModel()

        let storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)

        var options = [AnyHashable: Any]()
        options[NSMigratePersistentStoresAutomaticallyOption] = true
        options[NSInferMappingModelAutomaticallyOption] = true

        try storeCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.databasePath, options: options)

        self.storeCoordinator = storeCoordinator
        return storeCoordinator
    }

    private var objectModel: NSManagedObjectModel?

    private func getManagedObjectModel() throws -> NSManagedObjectModel {
        if let objectModel = self.objectModel {
            return objectModel
        }

        let momName = self.managedObjectModelName
        guard let modelUrl = Bundle.main.url(forResource: momName, withExtension:"momd") else {
            throw self.errorWithMessage("ACSwiftCoreData: DataModel Url could not be created.")
        }

        guard let objectModel = NSManagedObjectModel(contentsOf: modelUrl) else {
            throw self.errorWithMessage("ACSwiftCoreData: DataModel could not be loaded.")
        }

        self.objectModel = objectModel
        return objectModel
    }

    // MARK: Error handling

    private func errorWithMessage(_ message: String) -> NSError {
        let userInfo = [NSLocalizedDescriptionKey: message]
        let error = NSError(domain: "com.appcron.accomponents", code: 0, userInfo: userInfo)
        return error
    }

}

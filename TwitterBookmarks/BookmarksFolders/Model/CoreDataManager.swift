//
//  CoreDataManager.swift
//  TwitterBookmarks
//
//  Created by mac on 14/07/2022.
//

import Foundation
import CoreData


class CoreDataManager{
    
    static let shared = CoreDataManager(modelName: "MyFolders")
    
    //core Data managed object context
    //allows temporal manipulation of data that only persists after being saved
    
    //managed object model
    //model of item in core data
    
    //persistent store coordinator
    //serves as bridge b/n stored items and managed object context in both ways ie saving or retireving
    
    //Persistent Store Container
    //provides functionality required to working wiht core data
    
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    init(modelName: String){
        persistentContainer =  NSPersistentContainer(name: modelName)
    }
    
    func save(){
        if(viewContext.hasChanges){
            try? viewContext.save()
        }
    }
    
    //load persistance store
    func load(completion: (() -> ())? = nil){
        
       // load(completion: () -> ()? = nil) in case user wants to do somwting after loading
        //completion = nil if user doesnt want to do anything
        
        
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else{
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
    
}

extension CoreDataManager{
    func createFolder(_ folderName: String) -> Folder{
        let folder = Folder(context: viewContext)
        folder.id = UUID()
        folder.name = folderName
        save()
        return folder
    }
    
    func deleteFolder(_ folder: Folder){
        viewContext.delete(folder)
        save()
        
    }
    
    func createFoldersFetchedResultsController(filter: String? = nil) -> NSFetchedResultsController<Folder>{
        let request: NSFetchRequest<Folder> = Folder.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath:\Folder.name, ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        if let filter = filter{
            let predicate = NSPredicate(format: "text contains[cd] %@", filter)
            request.predicate = predicate
        }
        
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        
    }
}


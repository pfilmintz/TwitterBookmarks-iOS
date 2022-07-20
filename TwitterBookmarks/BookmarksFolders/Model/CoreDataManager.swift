//
//  CoreDataManager.swift
//  TwitterBookmarks
//
//  Created by mac on 14/07/2022.
//

import Foundation
import CoreData




class CoreDataManager  {
    
    //singletons wont work in structs cuz they are value types
    //they create a copy of the value bn accessed and changes that
    //hence defeating the idea of a singleton
    
    //changes to values in struct singleton on changes the original value but new value that was created my modifying it remains unchanged
    
    //prevent recreating
   // static var shared = CoreDataManager(modelName: "dsadas")
    static var shared = CoreDataManager(modelName: "TweetFolders")
     static var defaultClass = ""
     
  

    
   // private let modelName = ""
    
    //singleton object
    //prevent recreating
    //static let shared = CoreDataManager(modelName: "MyFolders")
    // static let shared = CoreDataManager()
    
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
    
    func fetchSavedTweets(_ folderName: String) -> NSOrderedSet?{
        let folderFetch: NSFetchRequest<TweetFolder> = TweetFolder.fetchRequest()
        
        folderFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(TweetFolder.name), folderName)
        do{
        let results = try viewContext.fetch(folderFetch)
            if results.count > 0 {
                // Folder found, use Folder
                let folder_tweet = results.first
                
                let tweets = folder_tweet?.savedtweets
                
                return tweets
                
            }else{
                return nil
            }
            
        }catch let error as NSError{
            return nil
        }
    }
    
   
    
    
    func addTweetToFolder(_ folderName: String,_ post: Tweet,_ type: String,_ urls: [String]){
        
        //insert newTweet into CoreData
        let tweet = SavedTweet(context: viewContext)
        
        tweet.text = post.text
        tweet.type = type
        tweet.media = urls
        tweet.key = post.id
        
        // Insert the newTweet into the Folder's walks set
        
        
        let folderFetch: NSFetchRequest<TweetFolder> = TweetFolder.fetchRequest()
        
        folderFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(TweetFolder.name), folderName)
        do{
        let results = try? viewContext.fetch(folderFetch)
        
      
            
        if results!.count > 0 {
            // Folder found, use Folder
            let folder_tweet = results?.first
            
            if let folder = folder_tweet,
                let tweets = folder.savedtweets?.mutableCopy()
                              as? NSMutableOrderedSet {
                tweets.add(tweet)
                folder.savedtweets = tweets
                
            }
            
            
        }
            
        }catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
          }
        
        save()
        
    }
    
    func createFolder(_ folderName: String) -> TweetFolder{
        let folder = TweetFolder(context: viewContext)
        
        folder.name = folderName
        save()
        return folder
    }
    
    func deleteFolder(_ folder: TweetFolder){
        viewContext.delete(folder)
        save()
        
    }
    
    func createFoldersFetchedResultsController(filter: String? = nil) -> NSFetchedResultsController<TweetFolder>{
        let request: NSFetchRequest<TweetFolder> = TweetFolder.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath:\TweetFolder.name, ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        if let filter = filter{
            let predicate = NSPredicate(format: "text contains[cd] %@", filter)
            request.predicate = predicate
        }
        
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        
    }
}


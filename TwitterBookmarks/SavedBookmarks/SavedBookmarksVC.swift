//
//  SavedBookmarksVC.swift
//  TwitterBookmarks
//
//  Created by mac on 17/07/2022.
//

import UIKit
import CoreData




class SavedBookmarksVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    init() {
           super.init(nibName: nil, bundle: nil)
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    var VCtitle = ""
    var folderName = ""
    
    var currentFolder: TweetFolder?
    
    var tweets: NSOrderedSet?
    var savedTweets = [localTweet]()
    
   
    
     let tableview: UITableView = {
        let tableview = UITableView()
        tableview.register(TextTableViewCell.self, forCellReuseIdentifier: TextTableViewCell.identifier)
        tableview.register(MediaTableViewCell.self, forCellReuseIdentifier: MediaTableViewCell.identifier)
        
        
        
        return tableview
        
    }()
    
    private var fetchedResultsController: NSFetchedResultsController<TweetFolder>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Main page view controller has loaded")
        
        navigationItem.title = VCtitle
        
        tableview.delegate = self
        tableview.dataSource = self
        
        view.addSubview(tableview)
        
        tableview.translatesAutoresizingMaskIntoConstraints = false
        
        
        tableview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        tableview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8).isActive = true
        tableview.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 8).isActive = true
        tableview.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8).isActive = true
        
        
        
        tweets = CoreDataManager.shared.fetchSavedTweets(folderName)
        
        //mapping tweets in core data to saved tweets fro tableview
        
        if let tweets = tweets {
        for tweet in tweets{
            let tweet = tweet as! SavedTweet
            
            let type = tweet.type as String?
            let post = tweet.text as String?
            let id = tweet.key as String?
            let url = tweet.media as [String]?
            
            //data in model
            let savedpost = localTweet(id: id ?? "", posttext: post ?? "",type: type ?? "", urls: url )
            
            savedTweets.append(savedpost)
            
            
            
            
        }
        }
        
        
        if(savedTweets.count > 0){
        tableview.reloadData()
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
   
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
       // #warning Incomplete implementation, return the number of sections
       return 1
   }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // #warning Incomplete implementation, return the number of rows
       // return tweets?.count ?? 0
        
        return savedTweets.count
   }
    
    var cellHeights = [IndexPath: CGFloat]()

     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }

     func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /*
         
         twitter://user?screen_name=lorenb

         twitter://user?id=12345

         twitter://status?id=12345

         twitter://timeline

         twitter://mentions

         twitter://messages

         twitter://list?screen_name=lorenb&slug=abcd

         twitter://post?message=hello%20world

         twitter://post?message=hello%20world&in_reply_to_status_id=12345

         twitter://search?query=%23hashtag
         
         */
        
        
        let id = savedTweets[indexPath.row].id
        
        let url = "https://twitter.com/twitter/status/\(id)"
        
    
        
        let lowerCaseSocialNetworkName = "twitter"
        
         let appURL = URL(string: "\(lowerCaseSocialNetworkName)://status?id=\(id)")!
         let application = UIApplication.shared
       
         if application.canOpenURL(appURL) {
            application.open(appURL)
         } else {
            let webURL = URL(string:url)
             application.open(webURL!)
         }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
      
        let tweet = savedTweets[indexPath.row]
        
        if(tweet.type == "photo" || tweet.type == "video"){
            let cell = tableView.dequeueReusableCell(withIdentifier: "MediaTableViewCell", for: indexPath)
            as! MediaTableViewCell
            
            
            //pass data from model to VM
            let savedTweet = savedTweetsMediaViewModel(tweet: tweet)
            
            //pass data from VM to View(cell)
           cell.loadSavedTweet(savedTweet)
            
            return cell
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell", for: indexPath)
            as! TextTableViewCell
            
            
            
            
            return cell
            
        }
        
        
        /*
        
        if let tweets = tweets {
            let tweet = tweets[indexPath.row] as! SavedTweet
            let type = tweet.type as String?
              if(type == "photo" || type == "video"){
                  let cell = tableView.dequeueReusableCell(withIdentifier: "MediaTableViewCell", for: indexPath)
                  as! MediaTableViewCell
                  
                  let post = tweet.text as String?
                  let id = tweet.key as String?
                  let url = tweet.media as [String]?
                  
                  //data in model
                  let savedpost = localTweet(id: id ?? "", posttext: post ?? "",type: type ?? "", urls: url )
                  
                  //pass data from model to VM
                  let savedTweet = savedTweetsMediaViewModel(tweet: savedpost)
                  
                  //pass data from VM to View(cell)
                 cell.loadSavedTweet(savedTweet)
                  
                  
                  return cell
              }else{
                  
                  let cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell", for: indexPath)
                  as! TextTableViewCell
                  
                  let post = tweet.text as String?
                  let id = tweet.key as String?
                  
                  return cell 
              }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell", for: indexPath)
            as! TextTableViewCell
            
            
            return cell
        }
        
        */
        
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SavedBookmarksVC: NSFetchedResultsControllerDelegate{
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableview.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableview.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type{
        case .insert:
            
            //aranges items alphabetically, Capitals first in alphabetical order, then smaller alphabets
            
            
            tableview.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            
           
            tableview.deleteRows(at: [indexPath!], with: .automatic)
        case.update:
            
            
            tableview.reloadRows(at: [indexPath!], with: .automatic)
            
        default: tableview.reloadData()
        }
    }
}

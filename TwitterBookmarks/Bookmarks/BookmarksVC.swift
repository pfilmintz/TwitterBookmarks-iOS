//
//  BookmarksVC.swift
//  TwitterBookmarks
//
//  Created by mac on 10/07/2022.
//

import UIKit





class BookmarksVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

   
    @IBOutlet weak var tableview: UITableView!
    
    var images: [Media]? = []
    
    
    var posts : [Tweet] = []
    
    //this creates a new instance of BookmarksViewModel
    private var viewModel = BookmarksViewModel()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        
        viewModel.retrieveBookmarks()
        
        
        setupBinders()
        
        
        //wont work becasue viewModel is a new instance of BookmarksViewModel ie 2 different instances of the BookmarksViewModel class
        
        //postsCallbak is not set in viewModel, and hence would not call the self.postsCallbak?(tweets) method in the BookmarksViewModel
        
        /*
        
        viewModel.postsCallbak = {[weak self] results in
            self?.posts = results
            self?.tableview.reloadData()
        }*/
       
    }
    
    private func setupBinders(){
        
        viewModel.tweetImages.bind { [weak self]  tweetImagesX in
            self?.images = tweetImagesX
        }
        
        viewModel.tweets.bind { [weak self] postz in
            DispatchQueue.main.async {
                self?.posts = postz
            self?.tableview.reloadData()
               
            }
            
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
       // #warning Incomplete implementation, return the number of sections
       return 1
   }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // #warning Incomplete implementation, return the number of rows
       return posts.count
   }
    
    var cellHeights = [IndexPath: CGFloat]()

     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }

     func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? UITableView.automaticDimension
    }
    
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var feedposts: Tweet?
        
        feedposts = posts[indexPath.row]
        
       
        
       
            
            if let imageKeys = feedposts?.attachments {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath)
                as! FeedTableViewCell
                
                if let images = images {
                    cell.viewModel.tweetImagesData = images
                }
                
                
                
                cell.loadViews(feedposts: feedposts)
       
                
            
                
                return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell", for: indexPath)
            as! TextTableViewCell
        
        
            cell.loadViews(feedposts: feedposts)
            
            return cell
        }
        
        
        
        
        
       
        
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

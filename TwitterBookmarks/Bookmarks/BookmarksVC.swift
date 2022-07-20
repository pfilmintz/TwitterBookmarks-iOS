//
//  BookmarksVC.swift
//  TwitterBookmarks
//
//  Created by mac on 10/07/2022.
//

import UIKit





class BookmarksVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    //VC basically receives data from VM and uses it to update UI
    //VC depends on VM ..VC === View
    
    //singleton is one instance of object in memory
    //cant create another instance of singleton

   
    private let tableview: UITableView = {
        let tableview = UITableView()
        tableview.register(MediaTableViewCell.self, forCellReuseIdentifier: MediaTableViewCell.identifier)
        
        tableview.register(TextTableViewCell.self, forCellReuseIdentifier: TextTableViewCell.identifier)
        
        return tableview
        
    }()
    
    var images: [Media]? = []
    
    
    var posts : [Tweet] = []
    
    var bookmarkFolderID = UUID()
    
    var VCtitle = ""
    
    
    //this creates a new instance of BookmarksViewModel
    private var viewModel = BookmarksViewModel()
    
    
    //private var viewModel = BookmarksViewModel(service: NetworkManager.shared)
  //  private var mediaCellViewModel = mediaTableViewCellViewModel()
    
    
    //private var viewModel = BookmarksViewModel(postsCallbak: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        navigationItem.title = VCtitle
        
        tableview.delegate = self
        tableview.dataSource = self
        
        view.addSubview(tableview)
        
        tableview.translatesAutoresizingMaskIntoConstraints = false
        
        
        tableview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        tableview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8).isActive = true
        tableview.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 8).isActive = true
        tableview.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8).isActive = true
        
        viewModel.retrieveBookmarks()
        
        
        setupBinders()
        
        
        //wont work becasue viewModel is a new instance of BookmarksViewModel ie 2 different instances of the BookmarksViewModel class
        //postsCallbak is not set in viewModel, and hence would not call the self.postsCallbak?(tweets) method in the BookmarksViewModel
        //because BookmarksViewModel() is new instance
        
        /*
        
        viewModel.postsCallbak = {[weak self] results in
            self?.posts = results
            self?.tableview.reloadData()
        }*/
        
        
       
    }
    
    private func setupBinders(){
        
        //write unit test to confirm VC changes when VM updates
        
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
        
       //mvvvm cell only handles UI stuff
        
       
            
            if let imageKeys = feedposts?.attachments {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "MediaTableViewCell", for: indexPath)
                as! MediaTableViewCell
                
                if let images = images {
                    cell.viewModel.tweetImagesData = images
                }
                
                
                cell.loadViews(feedposts: feedposts)
       
                cell.menuButtonAction = {[weak self] in
                    
                    //get data from tblviewmodel
                        //use data to saveTweet
                    
                    let savedTweet = cell.viewModel.savedTweets[feedposts!.id]
                    
                    if let savedTweet = savedTweet{
                    self?.addToBookmarkFolder(feedposts!,savedTweet.type,savedTweet.media,cell.viewModel)
                    }
                //    self?.addToBookmarkFolder(feedposts!,imageDetatils[0].type, )
                    
                /*    if let self = self{
                    
                        self.addToBookmarkFolder(feedposts!)
                }*/
                    
                }
            
                
                return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell", for: indexPath)
            as! TextTableViewCell
        
        
            cell.loadViews(feedposts: feedposts)
            
            
            
            return cell
        }
        
        
        
        
        
       
        
    }
    
    
    
    
    func addToBookmarkFolder(_ post: Tweet,_ type: String,_ urls: [String],_ viewModel: mediaTableViewCellViewModel){
        func printActionTitle(_ action: UIAlertAction) {
            // print("You tapped \(action.title!)")
            
            
            if action.title! == "Add to Bookmark"{
                
                
                /*     let yourVC = DummyViewController()
               yourVC.addToFolderCallback = { [weak self] result in
                    //self?.bookmarkFolderID = result
                    
                    
                   // self?.mediaCellViewModel.saveToFolder(post: post,type: type,urls: urls,folderId: result)
                    
                    viewModel.saveToFolder(post: post,type: type,urls: urls,folderId: result)
                    
                    }*/
                
                let yourVC = SelectBookmarkFolderVC()
               
               
                
                
               yourVC.addToFolderCallback = { [weak self] result in
                    //self?.bookmarkFolderID = result
                    
                    
                   // self?.mediaCellViewModel.saveToFolder(post: post,type: type,urls: urls,folderId: result)
                    
                   viewModel.saveToFolder(post: post,type: type,urls: urls,folderName: result)
                    
                    }
                
                

                if #available(iOS 15.0, *) {
                    if let sheet = yourVC.sheetPresentationController {
                        sheet.detents = [.medium()]
                    }
                } else {
                    // Fallback on earlier versions
                    
                    yourVC.modalPresentationStyle = .custom
                    yourVC.transitioningDelegate = self
                }
                self.present(yourVC, animated: true, completion: nil)
            }
            
        }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        
        
        alertController.addAction(UIAlertAction(title: "Add to Bookmark", style: .default, handler: printActionTitle))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: printActionTitle))
        self.present(alertController, animated: true, completion: nil)
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
extension BookmarksVC: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

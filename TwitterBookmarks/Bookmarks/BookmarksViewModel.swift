//
//  BookmarksViewModel.swift
//  TwitterBookmarks
//
//  Created by mac on 12/07/2022.
//

import Foundation


struct BookmarksViewModel {
    
    var tweets: TweetsObservableObject<[Tweet]> = TweetsObservableObject([])
    
    var tweetImages: ImagesObservableObject<[Media]?> = ImagesObservableObject([])
    
    
    //implicit refernce
    //Building NetworkManager/using it directly
    //decided or created in class/viewcontroller
    let networker = NetworkManager.shared
    
  //dependency injection
    
    //source is not decided in class/viewcontroller
    //asking for an instance of NetworkManager
    //
    //  let networker: NetworkManager = .shared - property injection
    //networker must be let
    
    //use property injection when view loads first storyboard since you cant use initializer constructor
    
    //can use new instance
    //let networker2: NetworkManager = NetworkManager()
    
    
    //initializer/constructor
    /* init(networker: NetworkManager){   injection
         self.networker = networker
     }*/
    
    //initializer  declared in class means its mandated in class and must be included when class/struct is created
    
    var posts : [Tweet] = []
    
    
    
    var images: [Media]? = []
                             
   /* func numberOrRows() -> Int {
            return self.posts.count
        }*/
    
    var postsCallbak: (([Tweet]) -> ())?
    
    
   /* init(service: NetworkManager){
        self.networker = service
    }*/
    
    
    
   
    

    func retrieveBookmarks(){
        let parameters = ["expansions":"attachments.media_keys", "media.fields": "media_key,preview_image_url,type,url"]
        
        
        
        networker.posts(parameters: parameters) {  tweetResults,imagesResult, error in
            if let error = error{
                print("error", error)
                return
            }
            
            
            
            guard let tweets = tweetResults else{
            return
            }
            
            self.tweets.value = tweets
            
           // will not be called because "var postsCallbak: (([Tweet]) -> ())?" is not see when viewModel is refered
          //  self.postsCallbak?(tweets)
            
            guard let tweetsImages = imagesResult?.media else{
            return
            }
            
            /*self?.posts = tweets
            self?.images = tweetsImages
             */
            
            
            self.tweetImages.value = tweetsImages
                        
          /*
           // self?.posts = posts!
            DispatchQueue.main.async {
               /* guard let posts = posts else{
                return
                }*/
                 print(tweetsImages)
                self?.tableview.reloadData()
            }*/
        }
    }
    
}

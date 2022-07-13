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
    
    
    let networker = NetworkManager.shared
    
    var posts : [Tweet] = []
    var images: [Media]? = []
                             
   /* func numberOrRows() -> Int {
            return self.posts.count
        }*/
    
  //  var postsCallbak: (([Tweet]) -> ())?
    
    
   
    

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

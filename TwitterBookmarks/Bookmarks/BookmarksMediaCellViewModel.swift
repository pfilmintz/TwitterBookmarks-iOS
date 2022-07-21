//
//  BookmarksMediaCellViewModel.swift
//  TwitterBookmarks
//
//  Created by mac on 21/07/2022.
//

import Foundation
import UIKit


struct mediaTableViewCellViewModel{
    
    var id: String?
    var posttext: String?
    var type: String?
    var urls: [String]?
    
    init(tweet: retrievedTweet){
           id = tweet.id
           posttext = tweet.posttext
           type = tweet.type
           urls = tweet.urls
           
       }
    
    //receives data from model from View
    
    var retrievedPosts: Tweet? = nil
    
    
    //gets needed data from model to be used by VM
    func getPost(tweet: Tweet?) -> retrievedTweet?{
        
        var type = ""
        var newtweetModel: retrievedTweet? = nil
        
        
        if let imageKeys = tweet?.attachments{
            
            if let images = tweetImagesData {
                
                let imageKeys = imageKeys.media_keys
                
                var urls = [String]()
                
                
                var imageDetatils = [Media]()
                
                
                    
                    for imageData in images{
                        
                        let key = imageData.media_key
                        
                        if(imageKeys.contains(key)){
                            //get url
                            
                            let imageDetail = Media(media_key: imageData.media_key , type: imageData.type , url: imageData.url ?? "" , preview_image_url: imageData.preview_image_url ?? "")
                            
                            imageDetatils.append(imageDetail)
                            
                        }
                         
                        
                     }
                
                type = imageDetatils[0].type
                
                for image in imageDetatils {
                    if(type == "photo"){
                    urls.append(image.url ?? "")
                    }
                    if(type == "video"){
                    urls.append(image.preview_image_url ?? "")
                    }
                }
                
                 newtweetModel = retrievedTweet(id: retrievedPosts?.id ?? "", posttext: retrievedPosts?.text ?? "", type: type, urls: urls)
                
                
            }
            
        }else{
             newtweetModel = retrievedTweet(id: retrievedPosts?.id ?? "", posttext: retrievedPosts?.text ?? "", type: "", urls: nil)
            
            
        }
        
        return newtweetModel
        
        
    }
    
    
    func LoadImages(completion: @escaping ([UIImage]?) -> ()){
        
        
            retrieveMultipleImages2(urls: urls ?? [],id: id ?? "") { download_images in
                if let images = download_images{
                    DispatchQueue.main.async {
                    completion(images)
                    }
                }else{
                    DispatchQueue.main.async {
                    completion(nil)
                    }
                
            }
            
        }
    }
    
    func LoadImage(completion: @escaping (UIImage?) -> ()){
        
            retrieveOneImage2(url: urls?[0] ?? "",id: id ?? "") { downloadedImage  in
                
                if let image_data = downloadedImage{
                    
                    DispatchQueue.main.async {
                        
                        //using return value from callbakc as return value for LoadImage function
                        completion(image_data)
                        
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        completion(nil)
                        
                    }
                    
            }
        }
        
    
            
        
        
    }
    
    
    
    
    //i want to return a value when the request is done so i pass a closure as a param
    func retrieveOneImage2(url: String,id: String, completion: @escaping (UIImage?) -> ()) {
        
        
        networker.image(url: url,id: id) { data, error in
            if let data = data {
                
             
                
                let image = UIImage(data: data)
                
                //return data from retrieveOneImage func
                completion(image)
               
               
                
                
                    
                }else{
               
                    completion(nil)
                    
                }
                
            }
        
            
        }
    
    func retrieveMultipleImages2(urls: [String],id: String, completion: @escaping ([UIImage]?) -> ()){
        
        
        //pass in urls and result of complettion
        networker.downloadImages(urls: urls, id: id) { data, images,error in
      
            
            var UIImages = [UIImage]()
                
                for picture in images{
                    
                    let image = UIImage(data: picture)
                    
                    UIImages.append(image!)
                    
                    
                    
                }
            
            
            completion(UIImages)

        }
        
     
        }
   
    
    
 
 
    
    //viewmodel doesnt depend on view
    
  //  let bookmarksViewModel = BookmarksViewModel()
    
    var savedTweets = [String:saveTweetData]()
    
    
    let networker: NetworkManager = .shared
    
    
    //receives data from BookmarksVc that listens to ntoifc from bookmarksVM
    //data is received from BookmarksVc through cell.feedTableViewCellViewModel.tweetImagesData
    var tweetImagesData: [Media]? = []
    
    
    
    
    func saveToFolder(post: Tweet,type: String, urls: [String],folderName: String ){
        
        
        CoreDataManager.shared.addTweetToFolder(folderName, post, type, urls)
        
        
    }
    
    
  
    
    
    //text: String?
    //id: String
    //media: [String]?
    
}

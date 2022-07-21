//
//  SavedTweetsMediaCellViewModel.swift
//  TwitterBookmarks
//
//  Created by mac on 21/07/2022.
//

import Foundation
import UIKit

struct savedTweetsMediaViewModel{
    
    let networker: NetworkManager = NetworkManager.shared
    
    var id: String
    var posttext: String
    var type: String
    var urls: [String]?
    
    //key of post mapped to keys of images attached
    var xImagesDic = [String: [String]]()
    
    //key of post mapped to data of images attached
    
    var imagesDataDisc = NSCache<NSString, NSArray>()
    
    
    
    init(tweet: localTweet){
        id = tweet.id
        posttext = tweet.posttext
        type = tweet.type
        urls = tweet.urls
        
    }
    
    
    //if loaded, retrieve image from cache
    //else
    //load from network
    
    
    //function accepts a closure as param and returns an image
    
    func LoadImages(completion: @escaping ([UIImage]?) -> ()){
        
        if let imagesData = imagesDataDisc.object(forKey: (id) as NSString){
            
            var images = [UIImage]()
            
            for picture in imagesData{
                
                let image = UIImage(data: picture as! Data)
          
                images.append(image!)
            }
            
            
            completion(images)
            
            
        }else{
            
            retrieveMultipleImages2(urls: urls ?? []) { download_images in
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
    }
    
    func LoadImage(completion: @escaping (UIImage?) -> ()){
        
      
        
        if let imageData = imagesDataDisc.object(forKey: (id) as NSString){
            
            let data = imageData[0]
            let image = UIImage(data: data as! Data)
            
            
            completion(image)
     
            
        }else{
            
           
            
           retrieveOneImage2(url: urls?[0] ?? "") { downloadedImage  in
                
                
            
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
        
    
            
        
        
    }
    
    //retrieve l=images from APi
    //store in cache
    //convert data to uiimage
    
    //i want to return a value when the request is done so i pass a closure as a param
    func retrieveOneImage2(url: String, completion: @escaping (UIImage?) -> ()) {
        
        
        networker.image(url: url) { data, error in
            if let data = data {
                
                //append image in array because we want to make this function usable for photos when we append it in images array in cache
                var imagesData = [Data]()
                imagesData.append(data)
                
                //append image to local cache
                self.imagesDataDisc.setObject(imagesData as NSArray, forKey: (id) as NSString)
                
                let image = UIImage(data: data)
                
                //return data from retrieveOneImage func
                completion(image)
               
               
                
                
                    
                }else{
               
                    completion(nil)
                    
                }
                
            }
        
            
        }
    
    func retrieveMultipleImages2(urls: [String], completion: @escaping ([UIImage]?) -> ()){
        
        
        //pass in urls and result of complettion
        networker.downloadImages(urls: urls) { data, images,error in
            
            
                var imagesData = [Data]()
            
            var UIImages = [UIImage]()
                
                for picture in images{
                    
                    let image = UIImage(data: picture)
                    
                    UIImages.append(image!)
                    
                imagesData.append(picture)
                    
                imagesDataDisc.setObject(imagesData as NSArray, forKey: (id) as NSString)
                    
                }
            
            
            completion(UIImages)

        }
        
     
        }
    
    
    
    
    
    
}

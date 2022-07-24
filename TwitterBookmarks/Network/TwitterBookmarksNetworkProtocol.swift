//
//  TwitterBookmarksNetworkProtocol.swift
//  TwitterBookmarks
//
//  Created by mac on 13/07/2022.
//

import Foundation

protocol TwitterBookmarksNetworkProtocol{
    
    func downloadImagesX(urls: [String],id: String,completion: @escaping (Data?,[Data],Error?) -> ())
    
   
    
    func downloadimageUrl(url: String,id: String) -> URL?
    
    func getPosts(parameters: [String: String],completion: @escaping ([Tweet]?,Includes?, Error?) -> ())
    
  
    
    func makeDownloadRequest(url: String,id: String,completion: @escaping (Data?,Error?) -> ())
    
}

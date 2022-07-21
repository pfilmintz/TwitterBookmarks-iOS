//
//  BookmarksModel.swift
//  TwitterBookmarks
//
//  Created by mac on 12/07/2022.
//

import Foundation



struct localTweet {
    var id: String
    var posttext: String
    var type: String
    var urls: [String]?
}

struct retrievedTweet {
    var id: String
    var posttext: String
    var type: String
    var urls: [String]?
}

struct Tweet: Codable{
    let id:String
    let text: String
    let attachments: Attachments?
   //
}

struct Attachments: Codable{
    
    let media_keys: [String]
    
}

struct Includes: Codable{
    
    let media: [Media]
    
}

struct Media: Codable{
    
    let media_key: String
    let type: String
    let url: String?
    let preview_image_url: String?
    
}

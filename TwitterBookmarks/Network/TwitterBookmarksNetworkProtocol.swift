//
//  TwitterBookmarksNetworkProtocol.swift
//  TwitterBookmarks
//
//  Created by mac on 13/07/2022.
//

import Foundation

protocol TwitterBookmarksNetworkProtocol{
    
    func getPosts(parameters: [String: String],completion: @escaping ([Tweet]?,Includes?, Error?) -> ())
    
}

//
//  MockTwitterResponseClient.swift
//  TwitterBookmarksTests
//
//  Created by mac on 13/07/2022.
//

import Foundation
@testable import TwitterBookmarks


class MockTwitterResponseClient{
    
    enum MockServiceError: Error{
        case noData
        case decodingFailed
        
        
    }
    
    var shouldReturnError = false
    var postsWereRetrieved = false
    
  
    
    
    
  /*  init(_ shouldReturnError:Bool){
        self.shouldReturnError = shouldReturnError
    }*/
    
  //  let MockData =  "{\"id\": 1}".data(using: .utf8)
    
  /*  let MockTwitterResponse: [String: Any] = [
        "data":
            ["id": "24234224","text": "testing","attachments": ["3545"]],
        "includes":
                ["media_key":"adsdsa","type": "video","url":"23423","preview_image_url":"dsdfdsf"]
    
    ]*/
   
    

    
}

extension MockTwitterResponseClient: TwitterBookmarksNetworkProtocol{
    
    
    
    
    func getPosts(parameters: [String : String], completion: @escaping ([Tweet]?,Includes?, Error?) -> ()) {
        
        var comp = URLComponents()
       
        comp.scheme = "https"
        comp.host = "api.twitter.com"
        
       comp.path = "/2/users/\(834009971746553856)/bookmarks"
        
        var queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                queryItems.append(URLQueryItem(name: key, value: value ))
            }
            comp.queryItems = queryItems
        
        var request = URLRequest(url: comp.url!)
        let BearerToken =  "Y3FldU1aUVdib2JYaFFtOTdBMGdYVG9IT3RrNHVna0JaSEU1UngxbHBMZXpuOjE2NTc3NTI0MTY3Njc6MTowOmF0OjE"
        
        request.addValue("Bearer \(BearerToken)", forHTTPHeaderField: "Authorization")
       
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                   let filePath = "twitter_bookmars_response"
            
            MockTwitterResponseClient.loadJsonDataFromFile(filePath, completion: { data in
                       if let json = data {
                           do {
                               let apiResponse = try JSONDecoder().decode(TwitterAPIResponse.self, from: json)
                               completion(apiResponse.data,apiResponse.includes, nil)
                           }
                           catch _ as NSError {
                               //fatalError("Couldn't load data from \(filePath)")
                               //coudlnt decode file, json structure cnahged
                               completion(nil,nil, MockServiceError.decodingFailed)
                           }
                       }else{
                           //failed to read from file
                           completion(nil,nil, MockServiceError.noData)
                       }
                   })
               }
        
        
        
    }
    
    private static func loadJsonDataFromFile(_ path: String, completion: (Data?) -> Void) {
        
      //  let bundlePath = Bundle(for: type(of: self)).path(forResource: name, ofType: "json")
        
        if let fileUrl = Bundle(for: MockTwitterResponseClient.self).url(forResource: path, withExtension: "json") {
               do {
                   let data = try Data(contentsOf: fileUrl, options: [])
                   completion(data as Data)
               } catch (let error) {
                   print(error.localizedDescription)
                   completion(nil)
               }
           }else{
               print("can decode")
           }
       }
}

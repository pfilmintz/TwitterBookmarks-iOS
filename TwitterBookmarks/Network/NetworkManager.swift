//
//  NetworkManager.swift
//  TwitterBookmarks
//
//  Created by mac on 10/07/2022.
//

import Foundation

enum NetworkManagerError: Error{
    case badResponse(URLResponse?)
    case badData
    case errorDecodingData
    case badLocalUrl
    case badUrl
    case errorDecodingImage
}

/*fileprivate struct APIResponse: Codable{
    let results: [Post]
}*/

 struct TwitterAPIResponse: Codable{
    let data: [Tweet]
    let includes: Includes
}


class NetworkManager{
    
    static var shared = NetworkManager()
    
    let session: URLSession
    
    private let cachedImages = [String: [Data]]()
    
  //  let url = URL(string: "https://api.twitter.com/2/users/")
    
    init(){
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    func components() -> URLComponents{
        
        //https://api.twitter.com/2/users/:id/bookmarks
        var comp = URLComponents()
       
        comp.scheme = "https"
        comp.host = "api.twitter.com"
        return comp
    }
    
    private func request(url: URL) -> URLRequest{
        var request = URLRequest(url: url)
        let BearerToken =  "T2tPLUZWMzItYmtiMnFNUW5GR0VkNi16Nmk3czNxY1EwNFpWX0pmMmZZamZ3OjE2NTgyODAwNDIxMTg6MTowOmF0OjE"
        
        request.addValue("Bearer \(BearerToken)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
 /*   func image(post: Post,completion: @escaping (Data?, Error?) -> ()){
        
        
        let task = session.downloadTask(with: URL(string: post.urls.regular)!) { localUrl, response, error in
            if let error = error{
                completion(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      completion(nil, NetworkManagerError.badResponse(response))
                      return
                  }
            
            guard let localUrl = localUrl else{
                completion(nil,NetworkManagerError.badLocalUrl)
                return
                
            }
            
            do{
                
                let data = try Data(contentsOf: localUrl)
                completion(data, nil)
                
            }catch let error{
                completion(nil,error)
            }
        }
        task.resume()
        
        
    }*/
    
    
    
    func downloadImages(urls: [String],completion: @escaping (Data?,[Data],Error?) -> ()){
        
        let group = DispatchGroup()
        var images = [Data]()
        
        var errorIfnoImagesareReturned =  NetworkManagerError.badUrl
        var dataIfAllImagesAreReturned = Data()
        
        for url in urls{
            //dispatch group calls brgin
            group.enter()
            let task = session.downloadTask(with: URL(string:url)!){
                localUrl, response, error in
                if let error = error {
                    completion(nil,images, error)
                    //dispatch group calls exits
                    group.leave()
                    return
                }
                
                //making sure httpResponse is within 200 range ie success
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                          completion(nil,images, NetworkManagerError.badResponse(response))
                          group.leave()
                          return
                      }
                //making sure data exists
                guard let localUrl = localUrl else{
                    group.leave()
                    completion(nil,images,NetworkManagerError.badLocalUrl)
                    return
                    
                }
                
                //decode data
                
                do{
                    
                    let data = try Data(contentsOf: localUrl)
                    dataIfAllImagesAreReturned  = data
                    images.append(data)
                    group.leave()
                    
                    
                }catch let error {
                    errorIfnoImagesareReturned = error as! NetworkManagerError
                    group.leave()
                }
            }
            task.resume()
            
            
        }
        
        group.notify(queue: .global()){
            //called when all group calls have bn executed
            print(images)
            
            if(images.count > 1){
                completion(dataIfAllImagesAreReturned, images,nil)
            }else{
                completion(nil,images,errorIfnoImagesareReturned)
            }
            
            
        }
        
        
    
    }

    
    func image(url: String,completion: @escaping (Data?,Error?) -> ()){
        let task = session.downloadTask(with: URL(string:url)!){
            localUrl, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            //making sure httpResponse is within 200 range ie success
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      completion(nil, NetworkManagerError.badResponse(response))
                      return
                  }
            //making sure data exists
            guard let localUrl = localUrl else{
                completion(nil,NetworkManagerError.badLocalUrl)
                return
                
            }
            
            //decode data
            
            do{
                
                let data = try Data(contentsOf: localUrl)
                completion(data, nil)
                
            }catch let error {
                completion(nil,error)
            }
        }
    task.resume()
    }
    
  //  func posts(uid: String,completion: @escaping ([Tweet]?, Error?) -> ()){
    
    //passing para and closure as parameters to be received when called
    
    //when being called
    
    /*
     
     posts(parameters: {param}) { //name[s] you want to call results of closure
     
     in
     
     body of code
    
    
}
     */
    
    
    
    func posts(parameters: [String: String],completion: @escaping ([Tweet]?,Includes?, Error?) -> ()){
        
        // path = ""
        
        
         var comp = components()
        comp.path = "/2/users/\(834009971746553856)/bookmarks"
         
        
        
         
         var queryItems = [URLQueryItem]()
             for (key, value) in parameters {
                 queryItems.append(URLQueryItem(name: key, value: value ))
             }
             comp.queryItems = queryItems
        
         let req = request(url: comp.url!)
        
        
        let task = session.dataTask(with: req) { data, response, error in
            //CHECKING for error
            if let error = error{
                completion(nil,nil, error)
                return
            }
            
            //making sure httpResponse is within 200 range ie success
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      completion(nil,nil, NetworkManagerError.badResponse(response))
                      return
                  }
            
            //making sure data exists
            guard let data = data else{
                completion(nil,nil,NetworkManagerError.badData)
                return
                
            }
            
            //decode data
            
            do{
                
                //test decoding logic if data is successfully received
                
                let apiResponse = try JSONDecoder().decode(TwitterAPIResponse.self, from: data)
                completion(apiResponse.data,apiResponse.includes, nil)
                
            }catch let error {
                completion(nil,nil,error)
            }
        }
        task.resume()
        
        
    }
}

//making NetworkManager class conform to TwitterBookmarksNetworkProtocol protocol
extension NetworkManager: TwitterBookmarksNetworkProtocol{
    func getPosts(parameters: [String: String],completion: @escaping ([Tweet]?,Includes?, Error?) -> ()){
        
        
         var comp = components()
        comp.path = "/2/users/\(834009971746553856)/bookmarks"
         
        
        
         
         var queryItems = [URLQueryItem]()
             for (key, value) in parameters {
                 queryItems.append(URLQueryItem(name: key, value: value ))
             }
             comp.queryItems = queryItems
        
         let req = request(url: comp.url!)
        
        
        let task = session.dataTask(with: req) { data, response, error in
            //CHECKING for error
            if let error = error{
                completion(nil,nil, error)
                return
            }
            
            //making sure httpResponse is within 200 range ie success
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      completion(nil,nil, NetworkManagerError.badResponse(response))
                      return
                  }
            
            //making sure data exists
            guard let data = data else{
                completion(nil,nil,NetworkManagerError.badData)
                return
                
            }
            
            //decode data
            
            do{
                
                
                
                let apiResponse = try JSONDecoder().decode(TwitterAPIResponse.self, from: data)
                completion(apiResponse.data,apiResponse.includes, nil)
                
            }catch let error {
                completion(nil,nil,error)
            }
        }
        task.resume()
        
        
    }
}

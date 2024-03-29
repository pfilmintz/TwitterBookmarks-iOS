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
    
    //key of post mapped to data of images attached
    var imagesDataDisc = NSCache<NSString, NSArray>()
    
    
  //  let url = URL(string: "https://api.twitter.com/2/users/")
    
    /*
     
     On the surface, dependency injection (DI) means we pass dependencies into an object. Instead of allowing the object to decide its dependencies, we tell the object what to use.
     DI is more than passing in instances. It promotes loosely coupled code that depends on protocols instead of concrete types. But we don’t have to go full- on with protocols to get benefits from DI. By providing a default, we give the object a way to specify its own dependency—unless it’s told otherwise.
     
     */
    
    //use singleton when you need to guarantee the uniquness of a class
    
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
        let BearerToken =  "YWFvVFg1OVE1X1ZOMWZCTmduN0haU0VFNk1RUDV3bTRQUjFQRU1kRVowbkV1OjE2NTg3NDI1MDQ4MzI6MToxOmF0OjE"
        
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
    
    
    
    func downloadImages(urls: [String],id: String,completion: @escaping (Data?,[Data],Error?) -> ()){
        
        var images = [Data]()
        if let imagesData = imagesDataDisc.object(forKey: (id) as NSString){
            
            
            for picture in imagesData{
                
                let image = picture as! Data
          
                images.append(image)
            }
            
            
            completion(nil,images,nil)
            
            return
            
            
        }
        
        let group = DispatchGroup()
        
        
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
                
                self.imagesDataDisc.setObject(images as NSArray, forKey: (id) as NSString)
                
                completion(dataIfAllImagesAreReturned, images,nil)
            }else{
                completion(nil,images,errorIfnoImagesareReturned)
            }
            
            
        }
        
        
    
    }
    
    

    
    func image(url: String,id: String,completion: @escaping (Data?,Error?) -> ()){
        
        if let imageData = imagesDataDisc.object(forKey: (id) as NSString){
            let data = imageData[0] as! Data
         //   print("\(imagesDataDisc) fuciomg IMAGES")
            
            completion(data,nil)
            
            return
            
        }
        
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
                
                //append image in array because we want to make this function usable for photos when we append it in images array in cache
                var imagesData = [Data]()
                imagesData.append(data)
                
                //append image to local cache
                self.imagesDataDisc.setObject(imagesData as NSArray, forKey: (id) as NSString)
                
                
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
    
    
    
    
    
   //original calls here
    
    //mocking class creasts a mock of calls here
    //for testing, calls in the mocking class will be called
    
    
    func makeURL(url: String) -> (URL?){
        let downloadUrl = URL(string: url)
        
        return downloadUrl
    }
    
    func makeDownloadRequest(url: String,id: String,completion: @escaping (Data?,Error?) -> ()){
        
      
        
        
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
    
    
    
    func downloadImagesX(urls: [String],id: String,completion: @escaping (Data?,[Data],Error?) -> ()){
        
        var images = [Data]()
        if let imagesData = imagesDataDisc.object(forKey: (id) as NSString){
            
            
            for picture in imagesData{
                
                let image = picture as! Data
          
                images.append(image)
            }
            
            
            completion(nil,images,nil)
            
            return
            
            
        }
        
        let group = DispatchGroup()
        
        
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
                
                self.imagesDataDisc.setObject(images as NSArray, forKey: (id) as NSString)
                
                completion(dataIfAllImagesAreReturned, images,nil)
            }else{
                completion(nil,images,errorIfnoImagesareReturned)
            }
            
            
        }
        
        
    
    }
    
    
    
    
    func downloadimageUrl(url: String,id: String) -> URL? {
        
        let downloadedUrl = URL(string: url)
        
        return downloadedUrl
    }
    
    
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

//
//  MockTwitterResponseClient.swift
//  TwitterBookmarksTests
//
//  Created by mac on 13/07/2022.
//

import Foundation
@testable import TwitterBookmarks


class MockTwitterResponseClient{
    
    //mocking real network calls
    //mocking Network Manager
    
    enum MockServiceError: Error{
        case noData
        case decodingFailed
        
        var errorDescription: String? {
            switch self{
            case .noData:
                return "No Data"
            case .decodingFailed:
                return "Decoding failed"
           
            }
            
        }
        
        
        
    }
    
    var shouldReturnError = false
    var postsWereRetrieved = false
    
    var shouldFailOnFetch:Bool = false
        var dataToReturnOnSuccess:Data?
    
  
 //   var networker: NetworkManager = .shared
    
   
    
    
    
    private var dataTask: URLSessionDataTask?
    
  
    
    let urlSession: URLSession
   
    init(urlSession: URLSession = .shared){
        
        self.urlSession = urlSession
    }

    
}

extension MockTwitterResponseClient: TwitterBookmarksNetworkProtocol{
    
    //mock requests here
    
    
    func makeDownloadRequest(url: String,id: String,completion: @escaping (Data?,Error?) -> ()){
        
        //check validity of Url and return Data is filepath isnt nil
        let downloadUrl = URL(string: url)
        
        if(downloadUrl == nil){
           
            completion(nil,MockServiceError.noData)
            return
        }
        
        
        let anyURL = downloadUrl!
        
        let bundle = Bundle(for: type(of:self))
        let filePath = bundle.path(
                     forResource: "play", ofType: "png")
        
        //mock data to be returned by fake urlSession.downloadTask (MockURLProtocol) and returned to test fxn
        let anyData = try?
                     Data(contentsOf:
                     URL(fileURLWithPath: filePath!))
        
        
        
                //let anyData = Data("any data".utf8)
                let anyResponse = HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
        
        
        MockURLProtocol.stub(url: anyURL, data: anyData, response: anyResponse, error: nil)

        
        urlSession.downloadTask(with: downloadUrl!) {  data, response, error in
            
            completion(anyData,nil)
            
            
            
        }.resume()
        
        
        
    }
    
    
    
    func downloadimageUrl(url: String, id: String) -> URL?  {
        
        let requestUrl = URL(string: url)
        
        return requestUrl
        
    }
    
    func downloadImagesX(urls: [String],id: String,completion: @escaping (Data?,[Data],Error?) -> ()){
        var images = [Data]()
        
        
        
        completion(nil,images,nil)
    }
    
    //
    
    
    
    //add test to check param of getposts
    
    
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

//
//  NetworkCallTests.swift
//  TwitterBookmarksTests
//
//  Created by mac on 13/07/2022.
//

import XCTest
@testable import TwitterBookmarks


class TwitterApiResponseTest: XCTestCase{
    
   // let networker = NetworkManager.shared
    
    /*
     
     Testing the network layer is about ensuring that the app calls the correct API endpoints with the right parameters,
     and ensuring that the app can deal with the response
     
     */
    
    var TwitterResponseApi: MockTwitterResponseClient!
    //let TwitterResponseApi = NetworkManager.shared
    
    
    //test making Url request ie conditions to ensure request is built succesfuly
    
    //test response
    
  //  var loader: APIRequestLoader<NetworkManager>!
    
    override func setUp() {
        
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        
        let urlSession = URLSession(configuration: config)
        
        TwitterResponseApi = MockTwitterResponseClient(urlSession: urlSession)
        
    }
    
    
    //test should fail if network task isnt initiated
    func test_download_image_success(){
        //this is what i am expecting
        let exp = expectation(description: "Return image from network")
        
        
        let url = "https://pbs.twimg.com/media/FYRYScgXwAM7BJ1?format=jpg&name=medium"
        let id = "1234"
        
        TwitterResponseApi.makeDownloadRequest(url: url, id: id) { imageData, error in
            
            
            XCTAssertNotNil(imageData)
            exp.fulfill()
            
        }
        //wait within a time frame for expectation to be fullfilled
        wait(for: [exp], timeout: 5)
        
        
        
    }
    
    
    
    /*
     for image tests, test url validity
     test decoding
     */
    
    
    
    
    
    func testing_main_response_returned_successfully(){
        
        //this is what i am expecting
        let exp = expectation(description: "Retrieve Bookmarks from Twitter and convert to model")
        
        
        let parameters = ["expansions":"attachments.media_keys", "media.fields": "media_key,preview_image_url,type,url"]
        
        
        TwitterResponseApi.getPosts(parameters: parameters) { tweetResults,imagesResult, error in
            
            //making sure data exists
            if let error = error {
            XCTFail("Error occured")
                return
            }
            
            do{
                
                if let tweets = tweetResults{
                    XCTAssertNotNil(tweets)
                }
                
                if let media = imagesResult{
                    XCTAssertNotNil(media)
                }
                
                //call this when response is receive from Asyn call to indicate expectation was met
                exp.fulfill()
                
            }catch let error {
                //do catch comes with its own error param
                XCTFail(error.localizedDescription)
            }
            
            
            
           
            
        }
        
            
        
        
        
        //wait within a time frame for expectation to be fullfilled
        wait(for: [exp], timeout: 5)
        
    }
    
}
/*private class NetworkManagerStub: NetworkManager{
    override func downloadimage(url: String, id: String, completion: @escaping (Data?, Error?) -> ()) {
        
    }
}*/

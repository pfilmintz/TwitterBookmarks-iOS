//
//  NetworkCallTests.swift
//  TwitterBookmarksTests
//
//  Created by mac on 13/07/2022.
//

import XCTest
@testable import TwitterBookmarks


class TwitterApiResponseTest: XCTestCase{
    
    let TwitterResponseApi = MockTwitterResponseClient()
    //let TwitterResponseApi = NetworkManager.shared
    
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

//
//  SavedBookmarksVCTests.swift
//  TwitterBookmarksTests
//
//  Created by mac on 22/07/2022.
//

import XCTest
@testable import TwitterBookmarks

class SavedBookmarksVCTests: XCTestCase {
    
    var sut: SavedBookmarksVC!
    
    override func setUp() {
        sut = SavedBookmarksVC()
       sut.loadViewIfNeeded()
        
        //loads VC and loads values first
        
    }

    func test_CanInit(){
        
        
            
        }
        
        func test_NavTitle_is_equal_to_folder_name(){
            
            
             //sut.VCtitle = "Random"
            
            
            //let navigationTitle = sut.navigationItem.title
            
            //XCTAssertEqual(navigationTitle, sut.VCtitle)
            
            //AssertEqual will fail since sut.navigationItem.title is "" at the time
            // navigationItem.title = VCtitle in VC is called
            // navigationItem.title will be "" from the VC since its value was loaded in the setUP()
        
            
            //we expect the value of the navifation title to be equal to value of vctitle
            XCTAssertEqual(sut.navigationItem.title, sut.VCtitle)
            //AssertEqual input, expected
            
        }
    
    func test_tableview_configured_delegate_datasource(){
        
        //checking same instance
        
        //flaw is this methid is coupled with the structure of code
        //it affirms that datasource nad delegate must be the sut
        //when datassource and delegate is moved from class, test will fail
        
        //test is tied up with implementation details hence will prevent future refactoring of code sicne test will have to change too
        
      //  XCTAssertIdentical(sut.tableview.dataSource, sut)
     //   XCTAssertIdentical(sut.tableview.dataSource, sut)
        
        //its better to just check presence of datasource and delegate
        
        XCTAssertNotNil(sut.tableview.dataSource, "dataSource")
        XCTAssertNotNil(sut.tableview.dataSource, "delegate")
        
        
    }
    
    func test_tableview_initial_state(){
        //tablview has 0 rows when viewdidload is initiaaly called
        XCTAssertEqual(sut.tableview.numberOfRows(inSection: 0), 0)
    }
        
        func test_fetched_tweets_from_CoreData(){
            
        }
    

}

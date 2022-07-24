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
    
    func test_cell_created_and_returning_right_cell(){
        //test to make sure right cell is returned base on posts model type
        
        //test fails because VCtitle is "" so cant retrieve tweets based on foldername
        
        var urls = [String]()
        urls.append("https://stackoverflow.com/questions/56269404/test-cell-in-a-uitableviewcell-xctest")
        
        //mimicing posts
        let savedpost = localTweet(id:"1234", posttext: "first post",type: "video", urls: urls )
        let savedpost2 = localTweet(id: "1233", posttext: "second post",type: "text", urls: nil )
        let savedpost3 = localTweet(id: "1333", posttext: "third post",type: "photo", urls: urls )
        
        sut.savedTweets.append(savedpost)
        sut.savedTweets.append(savedpost2)
        sut.savedTweets.append(savedpost3)
        
        
        guard let textcell = cellForRow(in: sut.tableview, row: 1) as? TextTableViewCell else{
            //test will fail if row returns mediacell for "text" type
           
            XCTFail("Code returns MediaCell based on post at specified row")
            return
        }
        
        //aserting cell inst nil
        XCTAssertNotNil(textcell)
        
        //assert cell contains right content
       
        XCTAssertNotNil(textcell.postTextLabel)
        
        guard let mediacell = cellForRow(in: sut.tableview, row: 0) as? MediaTableViewCell else{
            //test will fail if type doesnt meet functionality set in code
            //test should fail if type is not "photo" or "video"
            XCTFail("Code returns TextCell based on post at specified row")
            return
        }
        
        //aserting cell inst nil
        XCTAssertNotNil(mediacell)
        
        //assert cell contains right content
       
        XCTAssertNotNil(mediacell.postTextLabel)
        
        
    }
    
    func test_tableview_number_of_rows(){
        
        //testing to make sure numofrows == numbero of items in lost
         
        var urls = [String]()
        urls.append("https://stackoverflow.com/questions/56269404/test-cell-in-a-uitableviewcell-xctest")
        
        //mimicing posts
        let savedpost = localTweet(id:"1234", posttext: "first post",type: "video", urls: urls )
        let savedpost2 = localTweet(id: "1233", posttext: "second post",type: "text", urls: nil )
        let savedpost3 = localTweet(id: "1333", posttext: "third post",type: "photo", urls: urls )
        
        sut.savedTweets.append(savedpost)
        sut.savedTweets.append(savedpost2)
        sut.savedTweets.append(savedpost3)
        
       // let tbvNoR = viewController.skillsTableView.dataSource?.tableView(viewController.skillsTableView, numberOfRowsInSection: 0)
        
        let numOfRows = numberOfRows(in: sut.tableview)
        
        let expectedNumOfRows = 3
        
        XCTAssertEqual(numOfRows, expectedNumOfRows)
        
    }
    
    func test_item_displayed_in_cell() {
        
        //testing to make sure right items displayed in cell
        
        var urls = [String]()
        urls.append("https://stackoverflow.com/questions/56269404/test-cell-in-a-uitableviewcell-xctest")
        
        //mimicing posts
        let savedpost = localTweet(id:"1234", posttext: "first post",type: "video", urls: urls )
        let savedpost2 = localTweet(id: "1233", posttext: "second post",type: "text", urls: nil )
        let savedpost3 = localTweet(id: "1333", posttext: "third post",type: "photo", urls: urls )
        
        sut.savedTweets.append(savedpost)
        sut.savedTweets.append(savedpost2)
        sut.savedTweets.append(savedpost3)
        
        let cell = cellForRow(in: sut.tableview, row: 2) as? MediaTableViewCell
        
        XCTAssertEqual(cell?.postTextLabel.text, "third post")
        
       // let textcell = cellForRow(in: sut.tableview, row: 1) as? TextTableViewCell
        
        //should fail if cell.postTextLabel.text is not set or wirng value is set to it
       // XCTAssertEqual(textcell?.postTextLabel.text, "second post")
        
     
        
    }
    
    func test_tableview_initial_state(){
        //tablview has 0 rows when viewdidload is initiaaly called
        XCTAssertEqual(sut.numberOfTweets(), 0)
    }
        
        func test_fetched_tweets_from_CoreData(){
            
        }
    

}

private extension SavedBookmarksVC{
    
    func numberOfTweets() -> Int{
        tableview.numberOfRows(inSection:  tweetsSection)
        
    }
    
    private var tweetsSection: Int { 0 }
}

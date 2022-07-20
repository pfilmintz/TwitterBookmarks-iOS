//
//  SavedTweet+CoreDataProperties.swift
//  TwitterBookmarks
//
//  Created by mac on 19/07/2022.
//
//

import Foundation
import CoreData


extension SavedTweet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedTweet> {
        return NSFetchRequest<SavedTweet>(entityName: "SavedTweet")
    }

    @NSManaged public var type: String?
    @NSManaged public var text: String?
    @NSManaged public var key: String?
    @NSManaged public var media: [String]?
    @NSManaged public var tweetfolder: TweetFolder?

}

extension SavedTweet : Identifiable {

}

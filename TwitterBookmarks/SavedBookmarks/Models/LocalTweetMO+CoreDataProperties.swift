//
//  LocalTweetMO+CoreDataProperties.swift
//  TwitterBookmarks
//
//  Created by mac on 18/07/2022.
//
//

import Foundation
import CoreData


extension LocalTweetMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocalTweetMO> {
        return NSFetchRequest<LocalTweetMO>(entityName: "LocalTweet")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var key: String?
    @NSManaged public var text: String?
    @NSManaged public var media: [String]?
    @NSManaged public var type: String?

}

extension LocalTweetMO : Identifiable {

}

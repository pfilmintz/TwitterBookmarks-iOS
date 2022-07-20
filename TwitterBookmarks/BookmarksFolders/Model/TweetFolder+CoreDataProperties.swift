//
//  TweetFolder+CoreDataProperties.swift
//  TwitterBookmarks
//
//  Created by mac on 19/07/2022.
//
//

import Foundation
import CoreData


extension TweetFolder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TweetFolder> {
        return NSFetchRequest<TweetFolder>(entityName: "TweetFolder")
    }

    @NSManaged public var name: String?
    @NSManaged public var savedtweets: NSOrderedSet?

}

// MARK: Generated accessors for savedtweets
extension TweetFolder {

    @objc(insertObject:inSavedtweetsAtIndex:)
    @NSManaged public func insertIntoSavedtweets(_ value: SavedTweet, at idx: Int)

    @objc(removeObjectFromSavedtweetsAtIndex:)
    @NSManaged public func removeFromSavedtweets(at idx: Int)

    @objc(insertSavedtweets:atIndexes:)
    @NSManaged public func insertIntoSavedtweets(_ values: [SavedTweet], at indexes: NSIndexSet)

    @objc(removeSavedtweetsAtIndexes:)
    @NSManaged public func removeFromSavedtweets(at indexes: NSIndexSet)

    @objc(replaceObjectInSavedtweetsAtIndex:withObject:)
    @NSManaged public func replaceSavedtweets(at idx: Int, with value: SavedTweet)

    @objc(replaceSavedtweetsAtIndexes:withSavedtweets:)
    @NSManaged public func replaceSavedtweets(at indexes: NSIndexSet, with values: [SavedTweet])

    @objc(addSavedtweetsObject:)
    @NSManaged public func addToSavedtweets(_ value: SavedTweet)

    @objc(removeSavedtweetsObject:)
    @NSManaged public func removeFromSavedtweets(_ value: SavedTweet)

    @objc(addSavedtweets:)
    @NSManaged public func addToSavedtweets(_ values: NSOrderedSet)

    @objc(removeSavedtweets:)
    @NSManaged public func removeFromSavedtweets(_ values: NSOrderedSet)

}

extension TweetFolder : Identifiable {

}

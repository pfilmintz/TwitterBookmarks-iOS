//
//  Folder+CoreDataProperties.swift
//  TwitterBookmarks
//
//  Created by mac on 14/07/2022.
//
//

import Foundation
import CoreData


extension Folder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Folder> {
        return NSFetchRequest<Folder>(entityName: "Folder")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?

}

extension Folder : Identifiable {

}

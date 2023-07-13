//
//  Feed+CoreDataProperties.swift
//  macapp
//
//  Created by nick on 13/07/2023.
//
//

import Foundation
import CoreData


extension Feed {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Feed> {
        return NSFetchRequest<Feed>(entityName: "Feed")
    }

    @NSManaged public var name: String?
    @NSManaged public var url: String?

}

extension Feed : Identifiable {

}

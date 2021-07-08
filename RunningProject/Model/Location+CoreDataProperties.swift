//
//  Location+CoreDataProperties.swift
//  RunningProject
//
//  Created by Jonatan Wikström on 2021-07-08.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var timestamp: Date?
    @NSManaged public var run: Run?

}

extension Location : Identifiable {

}

//
//  PreLoadRun+CoreDataProperties.swift
//  RunningProject
//
//  Created by Jonatan Wikström on 2021-08-09.
//
//

import Foundation
import CoreData


extension PreLoadRun {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PreLoadRun> {
        return NSFetchRequest<PreLoadRun>(entityName: "PreLoadRun")
    }

    @NSManaged public var distance: Double
    @NSManaged public var preLoadLocations: NSOrderedSet?

}

// MARK: Generated accessors for preLoadLocations
extension PreLoadRun {

    @objc(insertObject:inPreLoadLocationsAtIndex:)
    @NSManaged public func insertIntoPreLoadLocations(_ value: PreLoadLocation, at idx: Int)

    @objc(removeObjectFromPreLoadLocationsAtIndex:)
    @NSManaged public func removeFromPreLoadLocations(at idx: Int)

    @objc(insertPreLoadLocations:atIndexes:)
    @NSManaged public func insertIntoPreLoadLocations(_ values: [PreLoadLocation], at indexes: NSIndexSet)

    @objc(removePreLoadLocationsAtIndexes:)
    @NSManaged public func removeFromPreLoadLocations(at indexes: NSIndexSet)

    @objc(replaceObjectInPreLoadLocationsAtIndex:withObject:)
    @NSManaged public func replacePreLoadLocations(at idx: Int, with value: PreLoadLocation)

    @objc(replacePreLoadLocationsAtIndexes:withPreLoadLocations:)
    @NSManaged public func replacePreLoadLocations(at indexes: NSIndexSet, with values: [PreLoadLocation])

    @objc(addPreLoadLocationsObject:)
    @NSManaged public func addToPreLoadLocations(_ value: PreLoadLocation)

    @objc(removePreLoadLocationsObject:)
    @NSManaged public func removeFromPreLoadLocations(_ value: PreLoadLocation)

    @objc(addPreLoadLocations:)
    @NSManaged public func addToPreLoadLocations(_ values: NSOrderedSet)

    @objc(removePreLoadLocations:)
    @NSManaged public func removeFromPreLoadLocations(_ values: NSOrderedSet)

}

extension PreLoadRun : Identifiable {

}

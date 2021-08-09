//
//  PreLoadLocation+CoreDataProperties.swift
//  RunningProject
//
//  Created by Jonatan Wikström on 2021-08-09.
//
//

import Foundation
import CoreData


extension PreLoadLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PreLoadLocation> {
        return NSFetchRequest<PreLoadLocation>(entityName: "PreLoadLocation")
    }

    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var preLoadRun: PreLoadRun?

}

extension PreLoadLocation : Identifiable {

}

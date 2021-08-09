//
//  Gubbholmen+CoreDataProperties.swift
//  RunningProject
//
//  Created by Jonatan Wikström on 2021-08-09.
//
//

import Foundation
import CoreData


extension Gubbholmen {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Gubbholmen> {
        return NSFetchRequest<Gubbholmen>(entityName: "Gubbholmen")
    }

    @NSManaged public var time: Int16
    @NSManaged public var timestamp: Date?

}

extension Gubbholmen : Identifiable {

}

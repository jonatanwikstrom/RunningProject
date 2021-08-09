//
//  KarlstadStadslopp+CoreDataProperties.swift
//  RunningProject
//
//  Created by Jonatan Wikström on 2021-08-09.
//
//

import Foundation
import CoreData


extension KarlstadStadslopp {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<KarlstadStadslopp> {
        return NSFetchRequest<KarlstadStadslopp>(entityName: "KarlstadStadslopp")
    }

    @NSManaged public var time: Int16
    @NSManaged public var timestamp: Date?

}

extension KarlstadStadslopp : Identifiable {

}

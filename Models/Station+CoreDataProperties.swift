//
//  Station+CoreDataProperties.swift
//  wherMaTrain
//
//  Created by etudiant01 on 06/04/2017.
//  Copyright © 2017 vivien. All rights reserved.
//

import Foundation
import CoreData


extension Station {

    @nonobjc public class func afetchRequest() -> NSFetchRequest<Station> {
        return NSFetchRequest<Station>(entityName: "Station")
    }

    @NSManaged public var address: String
    @NSManaged public var lat: Double
    @NSManaged public var long: Double
    @NSManaged public var name: String
    @NSManaged public var distanceToUser: Double
    @NSManaged public var lines: NSSet?

}

// MARK: Generated accessors for lines
extension Station {

    @objc(addLinesObject:)
    @NSManaged public func addToLines(_ value: Line)

    @objc(removeLinesObject:)
    @NSManaged public func removeFromLines(_ value: Line)

    @objc(addLines:)
    @NSManaged public func addToLines(_ values: NSSet)

    @objc(removeLines:)
    @NSManaged public func removeFromLines(_ values: NSSet)

}

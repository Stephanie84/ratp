//
//  Line+CoreDataProperties.swift
//  wherMaTrain
//
//  Created by etudiant01 on 06/04/2017.
//  Copyright © 2017 vivien. All rights reserved.
//

import Foundation
import CoreData


extension Line {

    @nonobjc public class func afetchRequest() -> NSFetchRequest<Line> {
        return NSFetchRequest<Line>(entityName: "Line")
    }

    @NSManaged public var id: String
    @NSManaged public var stations: NSSet?
    @NSManaged public var color : Int

}

// MARK: Generated accessors for stations
extension Line {

    @objc(addStationsObject:)
    @NSManaged public func addToStations(_ value: Station)

    @objc(removeStationsObject:)
    @NSManaged public func removeFromStations(_ value: Station)

    @objc(addStations:)
    @NSManaged public func addToStations(_ values: NSSet)

    @objc(removeStations:)
    @NSManaged public func removeFromStations(_ values: NSSet)

}

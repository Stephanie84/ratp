//
//  Station+CoreDataClass.swift
//  wherMaTrain
//
//  Created by etudiant01 on 06/04/2017.
//  Copyright © 2017 vivien. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON
import CoreLocation


public class Station: NSManagedObject {
    override init(entity: NSEntityDescription,insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    
    init(json: JSON) {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: "Station", in: context)!
    super.init(entity: entity, insertInto: context)
    self.name = json["name"].stringValue
    self.address = json["address"].stringValue
    self.lat = json["position"]["lat"].doubleValue
    self.long = json["position"]["long"].doubleValue
        let linesArray = json["lines"].arrayValue.map { $0.stringValue}
        linesArray.forEach {
            let request = Line.afetchRequest()
             let idToFetch = $0
             request.predicate = NSPredicate(format: "id == %@", idToFetch)
            do {
                let results: [Line] = try context.fetch(request)
                if results.count > 0 {
                    if let newLine = results.first{
                        self.addToLines(newLine)
                    }
                }
            else {
                    let newLine = Line(id: $0)
            self.addToLines(newLine)
        }
    }
            catch {
                print("error")
            }
        self.distanceToUser = 0.0
    }
    
    func setDistanceToUser (userPosition : CLLocation) {
        let position = CLLocation(latitude:self.lat, longitude: self.long)
        self.distanceToUser = position.distance(from: userPosition)
    }

}
}

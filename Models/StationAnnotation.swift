//
//  StationAnnotation.swift
//  wherMaTrain
//
//  Created by etudiant01 on 07/04/2017.
//  Copyright © 2017 vivien. All rights reserved.
//

import Foundation
import MapKit

class StationAnnotation: NSObject, MKAnnotation {
    fileprivate var coord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return coord
        }
    }
    
    var title: String?
    var subtitle: String?
    var lines : String?
    
    var station: Station?
    
    func setCoordinate(_ newCoordinate: CLLocationCoordinate2D) {
        self.coord = newCoordinate
    }
    
    // Build annotation from the item information
    func buildFromItem(_ station: Station) {
        
        self.setCoordinate(CLLocationCoordinate2D(latitude: station.lat, longitude: station.long))
        self.title = station.name
        //self.subtitle = station.address
        self.station = station
    }
}



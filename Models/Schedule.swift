//
//  Schedule.swift
//  wherMaTrain
//
//  Created by etudiant01 on 07/04/2017.
//  Copyright © 2017 vivien. All rights reserved.
//

import Foundation
import SwiftyJSON


struct Schedule {
    let arrival: String
    let destination: String
    
    init(json: JSON) {
        self.arrival = json["message"].stringValue
        self.destination = json["destination"].stringValue
    }
}

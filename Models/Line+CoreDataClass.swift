//
//  Line+CoreDataClass.swift
//  wherMaTrain
//
//  Created by etudiant01 on 06/04/2017.
//  Copyright © 2017 vivien. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON


public class Line: NSManagedObject {

    override init(entity: NSEntityDescription,insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    
    init(id: String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Line", in: context)!
        super.init(entity: entity, insertInto: context)
        self.id = id
        switch id {
        case "1":
            self.color = 0xffcd00
        case "2":
            self.color = 0x003ca6
        case "3":
            self.color = 0x837902
        case "38":
            self.color = 0x6ec4e8
        case "4":
            self.color = 0xcf009e
        case "5":
            self.color = 0xff7e2e
        case "6":
            self.color = 0x6eca97
        case "7":
            self.color = 0xfa9aba
        case "78":
            self.color = 0x6eca97
        case "8":
            self.color = 0xe19bdf
        case "9":
            self.color = 0xb6bd00
        case "10":
            self.color = 0xc9910d
        case "11":
            self.color = 0x704b1c
        case "12":
            self.color = 0x007852
        case "13":
            self.color = 0x6ec4e8
        case "14":
            self.color = 0x62259d
        default:
            self.color = 0x003ca6
        }

    }
}

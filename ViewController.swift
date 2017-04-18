//
//  ViewController.swift
//  wherMaTrain
//
//  Created by etudiant01 on 04/04/2017.
//  Copyright © 2017 vivien. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation
import CoreData

class ViewController: UIViewController {

    //let station : String?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var savedStation = [Station]()
    
    
    override func viewWillAppear(_ animated: Bool) {
    readJson()
    fetchStationsFromCoreData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
      
    }

    func readJson() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        guard let jsonURL = Bundle.main.url(forResource: "metros", withExtension: "json") else {
            print("Could not find Random-User.json!")
            return
        }
        let jsonData = try! Data(contentsOf: jsonURL)
        let metroData = JSON(data: jsonData)
        let metroArray = metroData["result"].arrayValue
        for station in metroArray {
            let currentStation = Station(json: station)
            //print("station is \(currentStation.name)")
            
        }
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
    }
    
    func fetchStationsFromCoreData() {
        do {
            let request: NSFetchRequest<Station> = Station.fetchRequest() as! NSFetchRequest<Station>
            let letter = "Y"
//            let myPredicate = NSPredicate(format: "name BEGINSWITH[c] %@",letter)
//            //let mySortDescriptor = NSSortDescriptor(key: "latestVaccine", ascending: false)
//            request.predicate = myPredicate
            savedStation = try context.fetch(request)
            savedStation.forEach{ print(" station latitude is \($0.lat)")}
        } catch {
            print("Fetching stations from Core Data failed :( ")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


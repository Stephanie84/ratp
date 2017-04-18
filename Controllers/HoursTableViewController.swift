//
//  HoursTableViewController.swift
//  wherMaTrain
//
//  Created by etudiant01 on 07/04/2017.
//  Copyright © 2017 vivien. All rights reserved.
//

import UIKit
import SwiftyJSON

class HoursTableViewController: UITableViewController {
    
    var line : String!

    var station : Station!
    var schedules = [Schedule]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    


    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
         self.navigationController?.navigationBar.isHidden = false
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.refreshControl = UIRefreshControl()
        self.tableView.addSubview(self.refreshControl!)
        self.refreshControl?.addTarget(self, action: #selector(self.handleRefresh), for: UIControlEvents.valueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        self.schedules.removeAll()
        
//Affichage des horaires en imageview
//        for line in lines {
//            NetworkManager.sharedInstance.getSchedulesForStation(station: self.station.name, linenumber: line.id, direction: Params.outbound, completion: { (json: JSON?, error: Error?) in
//                guard error == nil else {
//                    return
//                }
//                print("DATA IS \(json)")
//                if let json = json {
//                    let jsonArray = json["result"]["schedules"].arrayValue
//                    for schedules in jsonArray {
//                        let destination = Schedule(json: schedules)
//                        self.schedules.append(destination)
//                    }
//                }
//                //self.stations = self.stations.filter{$0.address.contains("75016")}
//            })
//        }
        NetworkManager.sharedInstance.getSchedulesForStation(station: self.station.name, linenumber: line, direction : Params.outbound, completion: { (json: JSON?, error: Error?) in
            guard error == nil else {
                return
            }
            print("DATA IS \(json)")
            if let json = json {
                let jsonArray = json["result"]["schedules"].arrayValue
                for schedules in jsonArray {
                    let destination = Schedule(json: schedules)
                    self.schedules.append(destination)
                }
            }
            //self.stations = self.stations.filter{$0.address.contains("75016")}
        })
        }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedules.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let schedulesToDisplay = schedules[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath) as! ScheduleTableViewCell
        cell.directionLabel.text = schedulesToDisplay.destination
        let lineSet = station.lines?.allObjects as! [Line]
        if let line = lineSet.filter({ $0.id == line}).first {
            print("\(line.color)")
        cell.directionLabel.textColor = UIColor(hex: line.color)
            }
        cell.arrivalLabel.text = schedulesToDisplay.arrival
        

        //lines[0].id
        return cell
    }
    
    func handleRefresh() {
        loadData()
        refreshControl?.endRefreshing()
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

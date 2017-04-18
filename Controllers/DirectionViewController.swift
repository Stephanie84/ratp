//
//  DirectionViewController.swift
//  wherMaTrain
//
//  Created by etudiant01 on 13/04/2017.
//  Copyright © 2017 vivien. All rights reserved.
//

import UIKit
import SwiftyJSON

class DirectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var line : String!
        var escapedLine: String!
    var station : Station!
    var schedulesAller = [Schedule]() {
        didSet {
            if segmentedControl.selectedSegmentIndex == 0 {
                self.tableView.reloadData()
            }
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()

    var schedulesRetour = [Schedule]() {
        didSet {
            if segmentedControl.selectedSegmentIndex == 1 {
                self.tableView.reloadData()
            }
        }
    }

    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    override func viewWillAppear(_ animated: Bool) {
        loadDataAller()
        loadDataRetour()
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.addSubview(self.refreshControl)
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadDataAller() {
        self.schedulesAller.removeAll()
        NetworkManager.sharedInstance.getSchedulesForStation(station: self.station.name, linenumber: escapedLine, direction : Params.outbound, completion: { (json: JSON?, error: Error?) in
            guard error == nil else {
                return
            }
            print("DATA IS \(json)")
            if let json = json {
                let jsonArray = json["result"]["schedules"].arrayValue
                for schedules in jsonArray {
                    let destination = Schedule(json: schedules)
                    self.schedulesAller.append(destination)
                }
            }
            //self.stations = self.stations.filter{$0.address.contains("75016")}
        })
    }
    
    func loadDataRetour() {
        self.schedulesRetour.removeAll()
        NetworkManager.sharedInstance.getSchedulesForStation(station: self.station.name, linenumber: escapedLine, direction : Params.inbound, completion: { (json: JSON?, error: Error?) in
            guard error == nil else {
                return
            }
            print("DATA IS \(json)")
            if let json = json {
                let jsonArray = json["result"]["schedules"].arrayValue
                for schedules in jsonArray {
                    let destination = Schedule(json: schedules)
                    self.schedulesRetour.append(destination)
                }
            }
            //self.stations = self.stations.filter{$0.address.contains("75016")}
        })
    }

    
    // MARK: - Table view data source
    
   func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if segmentedControl.selectedSegmentIndex == 0 {
        return schedulesAller.count
    }
    else if segmentedControl.selectedSegmentIndex == 1 {
        return schedulesRetour.count
    }
    return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var schedulesToDisplay : Schedule?
        if segmentedControl.selectedSegmentIndex == 0 {
            schedulesToDisplay = schedulesAller[indexPath.row]
        }
        else if segmentedControl.selectedSegmentIndex == 1 {
            schedulesToDisplay = schedulesRetour[indexPath.row]
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath) as! ScheduleTableViewCell
        cell.directionLabel.text = schedulesToDisplay!.destination
        let lineSet = station.lines?.allObjects as! [Line]
        if let line = lineSet.filter({ $0.id == line}).first {
            print("\(line.color)")
            cell.directionLabel.textColor = UIColor(hex: line.color)
        }
        cell.arrivalLabel.text = schedulesToDisplay!.arrival
        
        
        //lines[0].id
        return cell
    }
    
   
    @IBAction func segmentedControlChange(_ sender: UISegmentedControl) {
        self.tableView.reloadData()
    }
    
    
    func handleRefresh() {
        loadDataAller()
        loadDataRetour()
        refreshControl.endRefreshing()
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

//
//  TableViewController.swift
//  wherMaTrain
//
//  Created by etudiant01 on 06/04/2017.
//  Copyright © 2017 vivien. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UISearchResultsUpdating, LineButtonDelegate {
    var station : Station!
    var selectedLine : String?
    var currentIndexPath: IndexPath?
    let searchController = UISearchController(searchResultsController: nil)
    var filteredStations = [Station](){
        didSet {
            self.tableView.reloadData()
        }
    }
    var stations = [Station]() {
    didSet {
    self.tableView.reloadData()
    }
}

    func filterContentForSearchText(searchText: String) {
        filteredStations = stations.filter { station in
            return station.name.folding(options: [.diacriticInsensitive, .caseInsensitive] , locale : .current ).contains(searchText.folding(options: [.diacriticInsensitive, .caseInsensitive] , locale : .current ))
//            lowercased().contains(searchText.lowercased())
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchStationsFromCoreData()

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredStations.count
        }
        return stations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stationCell", for: indexPath) as! StationTableViewCell
        let station : Station
        if searchController.isActive && searchController.searchBar.text != "" {
            station = filteredStations[indexPath.row]
        }
        else {
            station = stations[indexPath.row]
            }
        let lines = station.lines?.allObjects as! [Line]
        cell.nameStationLabel.text = station.name
        cell.indexPath = indexPath
        cell.configureCell(lines: lines)
        cell.delegate = self
        return cell
    }
    
    func lineSelected(indexPath: IndexPath, lineNumber: String) {
        print("lineSelected \(lineNumber)")
        self.selectedLine = "\(lineNumber)"
        self.currentIndexPath = indexPath
        self.performSegue(withIdentifier: "toHours", sender: self)
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var station: Station?
        if (segue.identifier == "toHours"){
            let myDestination = segue.destination as! DirectionViewController
            if searchController.isActive && searchController.searchBar.text != "" {
                station = filteredStations[currentIndexPath!.row]
            }
            else {
                station = stations[currentIndexPath!.row]
            }
            if selectedLine == "78" {
                myDestination.escapedLine = "7B"
            }
            else if selectedLine == "38" {
                myDestination.escapedLine = "3B"
            }
            else {
                myDestination.escapedLine = selectedLine
            }
            myDestination.line = selectedLine
            myDestination.station = station
        }
    }
    
    func fetchStationsFromCoreData() {
        let appDel = (UIApplication.shared.delegate as! AppDelegate)
        let context = appDel.persistentContainer.viewContext
        do {
            stations = try context.fetch(Station.fetchRequest()) as! [Station]
        } catch {
            print("Fetchfailed :( ")
        }
    }


}

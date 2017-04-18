//
//  MapViewController.swift
//  wherMaTrain
//
//  Created by etudiant01 on 07/04/2017.
//  Copyright © 2017 vivien. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SwiftyJSON
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var stations = [Station]()
    var stationToSend : Station?
    var selectedLine : String?
    let locationManager = CLLocationManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    func requestLocationAccess() {
        // Lire les permissions utilisateurs pour la localisation
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
            
        case .denied, .restricted:
            print("location access denied")
            
        default:
            locationManager.requestWhenInUseAuthorization()
            // Demander l'accès à l'utilisation
        }
    }
    
    func initUserLocation(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        requestLocationAccess()
        locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchStationsFromCoreData()
        //addStations()
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") ??
            MKAnnotationView()
        annotationView.annotation = annotation
        if let stationInfo = annotation as? StationAnnotation {
            annotationView.image = UIImage(named: "M")// mettre une image
            annotationView.canShowCallout = true
            let lines = stationInfo.station?.lines?.allObjects as! [Line]
            let calloutView = UIView()
            let views = ["snapshotView": calloutView]
            calloutView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[snapshotView(25)]", options: [], metrics: nil, views: views))
            calloutView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[snapshotView(100)]", options: [], metrics: nil, views: views))
            var initialX = 0
            for line in lines {
                let line1image = UIImage(named: "M_\(line.id)")
                let line1button = UIButton(type: .custom)
                line1button.setImage(line1image, for: .normal)
                line1button.tag = Int(line.id) ?? 0
                line1button.addTarget(self, action: #selector(MapViewController.lineTapped), for: .touchUpInside)
                line1button.frame = CGRect(x: initialX, y: 0, width: 20, height: 20)
                calloutView.addSubview(line1button)
                initialX += 30
            }
            annotationView.detailCalloutAccessoryView = calloutView
            }
            annotationView.frame.size = CGSize(width: 20, height: 20) // resizer l'image
        
            
            return annotationView
        }
    
    func lineTapped(button: UIButton){
        print("LINE BUTTON TAPPED")
        self.selectedLine = "\(button.tag)"
        self.performSegue(withIdentifier: "toStation", sender: self)
        
        
    }
    
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        if let stationInfo = view.annotation as? StationAnnotation {
//            annotationView.image = UIImage(named: "M")// mettre une image
//            annotationView.canShowCallout = true
//            let myWidth = 36
//            let myHeight = 40
//            let metrosLabel =  UILabel(frame: CGRect(x: 0, y: 0, width: myWidth, height: myHeight * 2/3))
//            let lines = stationInfo.station?.lines?.allObjects as! [Line]
//            let line1image = UIImage(named: "M_\(lines.first?.id)")
//            let line1imageView = UIImageView(image: line1image)
//            line1imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//            annotationView.detailCalloutAccessoryView?.addSubview(line1imageView)
//            
//        }
//    }
    
    func addPin(name: String, station: Station){
        //creer une annotation de type station un seul
        let pinAnnotation = StationAnnotation()
        // charger une station dans l'annotation (mais pas la voir)
        pinAnnotation.buildFromItem(station)
        pinAnnotation.title = name
        mapView.addAnnotation(pinAnnotation)
    }
    
    func addStations(){
        mapView.removeAnnotations(mapView.annotations)
        let location = CLLocation(latitude: (stations.first!.lat), longitude: (stations.first!.long))
        self.setDiameter(location: location)
        
        for station in stations {
            addPin(name: station.name, station: station)
        }
    }
    
    func fetchStationsFromCoreData() {
        do {
            let request: NSFetchRequest<Station> = Station.fetchRequest() as! NSFetchRequest<Station>

            //            let myPredicate = NSPredicate(format: "name BEGINSWITH[c] %@",letter)
            //            //let mySortDescriptor = NSSortDescriptor(key: "latestVaccine", ascending: false)
            //            request.predicate = myPredicate
           stations = try context.fetch(request)
         addStations()
           stations.forEach{ print(" \($0.lat),\($0.long)")}
        } catch {
            print("Fetching stations from Core Data failed :( ")
        }
    }

    
    //methode quand on clic sur le bouton droit ou accesory d un pin
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let stationInfo = view.annotation as? StationAnnotation {
            // deselectionner la bulle
            mapView.deselectAnnotation(view.annotation, animated: true)
            if let myStation = stationInfo.station {
                stationToSend = myStation
                
            }
        }
        
    }
    
    func setDiameter(location: CLLocation) {
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        mapView.setRegion(region, animated: true)
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


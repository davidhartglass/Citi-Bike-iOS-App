//
//  CitiBikeDetailViewController.swift
//  Citi Bike Locator
//
//  Created by David Hartglass on 4/25/18.
//  Copyright © 2018 David Hartglass. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


//Class to make an annotation (pin) for the exact location of the bike
final class BikeAnnotation: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?){
        self.coordinate = coordinate
        self.title = title
        super.init()
    }
    var region: MKCoordinateRegion{
        let span = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
        return MKCoordinateRegion(center: coordinate, span: span)
    }
}

let locationManager = CLLocationManager()
class CitiBikeDetailViewController: UIViewController, CLLocationManagerDelegate {
    
    var rowNum: Int?
    var myModel: CitiBikeCollection?
    let newPin = MKPointAnnotation()
    let locationManager =  CLLocationManager()
    
    @IBOutlet weak var mapLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var lastCommTimeLabel: UILabel!
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var distanceFromBike: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the border of the labels in the detail view
        
        idLabel.layer.borderWidth = 2.0
        idLabel.layer.cornerRadius = 8
        lastCommTimeLabel.layer.borderWidth = 2.0
        lastCommTimeLabel.layer.cornerRadius = 8
        stationNameLabel.layer.borderWidth = 2.0
        stationNameLabel.layer.cornerRadius = 8
        distanceFromBike.layer.borderWidth = 2.0
        distanceFromBike.layer.cornerRadius = 8
        
        
        //MARK: Location manager
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        var currentLocation: CLLocation!
        var isActivated: Bool?
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = locationManager.location
            isActivated = true
            
        }
        
        var count: Int = 0
        if isActivated == true {
            
            //Get the coordinate of the bike from the model
            let coordinate0 = CLLocation(latitude: (myModel?.currentBikes[rowNum!].latitude)!, longitude: (myModel?.currentBikes[rowNum!].longitude)!)
            
            //Pass the users location coordinates from the device
            
            let coordinate1 = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            
            //Since the coordinate distance is calculated in meters, we grab the distance and convert it into miles
            let distanceInMeters = coordinate0.distance(from: currentLocation)
            let distanceInMiles = (distanceInMeters/1609.344)
            
            //Using a formatter to set the precision of the miles to two points after the decimal point
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            
            //Convert the formatted double into a string value
            
            let formattedAmount = formatter.string(from: distanceInMiles as NSNumber)!
            
            distanceFromBike.text = " Distance (Miles): \(formattedAmount) "
            count = count + 1
        }
        
        
        idLabel.text = " Bike ID: \(myModel!.currentBikes[rowNum!].id) "
        lastCommTimeLabel.text = " Last Communication: \(myModel!.currentBikes[rowNum!].lastCommunicationTime) "
        stationNameLabel.text = " Station: " + myModel!.currentBikes[rowNum!].stationName + " "
        
        if count == 0 {
            distanceFromBike.text = " Location Unavailable "
        }
        else{
            
        }
        
        mapLoadingIndicator.hidesWhenStopped = true
        mapLoadingIndicator.startAnimating()
        
        myMapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        let myCoordinate = CLLocationCoordinate2DMake((myModel?.currentBikes[rowNum!].latitude)!, (myModel?.currentBikes[rowNum!].longitude)!)
        
        let bikeAnnotation = BikeAnnotation(coordinate: myCoordinate, title: myModel?.currentBikes[rowNum!].stationName)
        
        myMapView.addAnnotation(bikeAnnotation)
        myMapView.setRegion(bikeAnnotation.region, animated: true)
        mapLoadingIndicator.stopAnimating()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//An extension to the UIViewController object to reuse the marker annotation
extension UIViewController: MKMapViewDelegate{
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let theBikeAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView{
            theBikeAnnotation.animatesWhenAdded = true
            theBikeAnnotation.titleVisibility = .adaptive
            
            return theBikeAnnotation
        }
        return nil
    }
}

//
//  ViewController.swift
//  HighWaters
//
//  Created by David E Bratton on 11/19/18.
//  Copyright © 2018 David Bratton. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseDatabase

class MainVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    private var rootRef: DatabaseReference!
    private var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get root reference or location of your Firebase DB
        self.rootRef = Database.database().reference()
        loadMapProperties()
        populateFloodLocation()
    }
    
    @IBAction func addAnnotation(_ sender: Any) {
        addAnnotation()
    }
}

extension MainVC: CLLocationManagerDelegate, MKMapViewDelegate {
    func loadMapProperties() {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        self.locationManager.startUpdatingLocation()
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let coordinate = location.coordinate
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    func addAnnotation() {
        if let location = self.locationManager.location {
            let floodAnnotation = MKPointAnnotation()
            floodAnnotation.coordinate = location.coordinate
            self.mapView.addAnnotation(floodAnnotation)
            let coordinate = location.coordinate
            let flood = Flood(latitude: coordinate.latitude, longitude: coordinate.longitude)
            // "flooded-regions" can be named whatever you want
            let floodedRegionsRef = self.rootRef.child("flooded-regions")
            let floodLocation = floodedRegionsRef.childByAutoId()
            floodLocation.setValue(flood.toDictionary())
        }
    }
    
    func populateFloodLocation() {
        let floodedRegionsRef = self.rootRef.child("flooded-regions")
        floodedRegionsRef.observe(.value) { (snapshot) in
            self.mapView.removeAnnotations(self.mapView.annotations)
            let floodDictionaries = snapshot.value as? [String:Any] ?? [:]
            for (key, _) in floodDictionaries {
                if let floodDict = floodDictionaries[key] as? [String: Any] {
                    if let flood = Flood(dictionary: floodDict) {
                        DispatchQueue.main.async {
                            let floodAnnotation = MKPointAnnotation()
                            floodAnnotation.coordinate = CLLocationCoordinate2D(latitude: flood.latitude, longitude: flood.longitude)
                            self.mapView.addAnnotation(floodAnnotation)
                        }
                    }
                }
            }
        }
    }
}

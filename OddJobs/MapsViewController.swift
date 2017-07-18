//
//  MapsViewController.swift
//  OddJobs
//
//  Created by Nicolas Rodriguez on 7/12/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import MapKit
import Parse

class MapsViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    let locationManager = CLLocationManager()
    var jobs: [PFObject] = []
    var initalLocation: MKUserLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestLocationAccess()
        queryServer()
        mapView.showsUserLocation = true
        mapView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    func requestLocationAccess() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
            
        case .denied, .restricted:
            print("location access denied")
            
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius*2, regionRadius*2)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func createAnnotations(jobs: [PFObject], map: MKMapView) {
        map.addAnnotation(map.userLocation)
        for job in jobs {
            let latitude = job["latitude"] as! CLLocationDegrees
            let longitude = job["longitude"] as! CLLocationDegrees
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let annotation = Job(title: job["title"] as? String, subtitle: job["description"] as? String, location: coordinate)
            map.addAnnotation(annotation)
        }
    }
    
    func queryServer() {
        let query = PFQuery(className: "Job")
        query.addDescendingOrder("createdAt")
        query.includeKey("userPosted")
        query.includeKey("location")
        query.limit = 25
        
        query.findObjectsInBackground { (jobs: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.jobs = jobs!
                self.createAnnotations(jobs: self.jobs, map: self.mapView)
            }
        }
    }
    
}

extension MapsViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if initalLocation == nil {
            initalLocation = userLocation
            centerMapOnLocation(location: userLocation.location!)
        }
    }
    
}

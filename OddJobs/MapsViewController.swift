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
                print("query worked")
                self.jobs = jobs!
                for job in self.jobs {
                    let latitude = job["latitude"] as! CLLocationDegrees
                    let longitude = job["longitude"] as! CLLocationDegrees
                    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    let annotation = Job(title: job["title"] as? String, subtitle: job["description"] as? String, location: coordinate)
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
    }
    
}

extension MapsViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let userLocation = mapView.userLocation.location {
            centerMapOnLocation(location: userLocation)
        }
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        print("annotation view")
//        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
//        return annotationView
//    }
}

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
    
    var jobs: [PFObject] = []
    var initalLocation: MKUserLocation?
    var annotations: [Job] = []
    var currentJob: PFObject?
    let regionRadius: CLLocationDistance = 1000
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestLocationAccess()
        queryServer()
        mapView.showsUserLocation = true
        mapView.delegate = self
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
            annotations.append(annotation)
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
    
    func buttonSegue(sender: UIButton!) {
        performSegue(withIdentifier: "mapDetailSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapDetailSegue" {
            let vc = segue.destination as! DetailViewController
            vc.job = currentJob!
        }
    }
    
    @IBAction func userCenter(_ sender: Any) {
        if let userLocation = mapView.userLocation.location {
            centerMapOnLocation(location: userLocation)
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.title! != "My Location" {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
            button.setTitle("segue", for: .normal)
            button.titleLabel?.text = "details"
            button.addTarget(self, action: #selector(buttonSegue), for: .touchUpInside)
            
            pinView.rightCalloutAccessoryView = button
            pinView.canShowCallout = true
            return pinView
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        for job in jobs {
            let latitude = job["latitude"] as! CLLocationDegrees
            let longitude = job["longitude"] as! CLLocationDegrees
            let title = job["title"] as? String
            let subtitle = job["description"] as? String
            if let annotation = view.annotation {
                if latitude == annotation.coordinate.latitude && longitude == annotation.coordinate.longitude {
                    if title == annotation.title! && subtitle == annotation.subtitle! {
                       currentJob = job
                    }
                }
            }
        }
    }
    
}

//
//  DetailViewController.swift
//  OddJobs
//
//  Created by Melody Ann Seda Marotte on 7/17/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import MapKit

class DetailViewController: UIViewController {
    
    var job: PFObject!
    var initialLocation: MKUserLocation?
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var jobPostPFImageView: PFImageView!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var dificultyLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var datePostedLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var skillsLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func requestJob(_ sender: UIBarButtonItem) {
        savejobData()
    }
   
    
    func savejobData() {
        let currentUser = PFUser.current()
        
        if self.job["usersInterested"] == nil{
            
            var usersInterested: [PFUser]! = []
            usersInterested.append(currentUser!)
            self.job["usersInterested"] = usersInterested as! [PFUser]
            print("user saved!")
            self.job.saveInBackground().continue({ (task:BFTask<NSNumber>) -> Any? in
                self.saveUserData()
                
            })
            
        } else {
            var usersInterested = self.job["usersInterested"] as! [PFUser]
            usersInterested.append(currentUser!)
            self.job["usersInterested"] = usersInterested
            self.job.saveInBackground().continue({ (task:BFTask<NSNumber>) -> Any? in
                self.saveUserData()
            })
        }

        
    }
    
    func saveUserData() {
        let currentUser = PFUser.current()
        
        if currentUser?["jobsInterested"] == nil {
            var jobsInterested: [PFObject] = []
            jobsInterested.append(self.job)
            currentUser?["jobsInterested"] = jobsInterested
            currentUser?.saveInBackground().continue({ (task: BFTask<NSNumber>) -> Any? in
               self.requestSentAlert()
                
            })
            
        } else {
            var jobsInterested = currentUser?["jobsInterested"] as! [PFObject]
            jobsInterested.append(self.job)
            currentUser?["jobsInterested"] = jobsInterested
            currentUser?.saveInBackground().continue({ (task: BFTask<NSNumber>) -> Any? in
                self.requestSentAlert()
            })
            print("saved interested job")
        }
        
    }
    
    
    func requestSentAlert() {
            let alertController = UIAlertController(title: "Job Request Sent!", message: "Please await approval", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
            }
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestLocationAccess()
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.isZoomEnabled = false
        mapView.isPitchEnabled = false
        mapView.isScrollEnabled = false
        mapView.isRotateEnabled = false
        
        jobPostPFImageView.file = job["image"] as! PFFile
        jobPostPFImageView.loadInBackground()
        
        jobTitleLabel.text = job["title"] as? String
        
        dificultyLabel.text = job["difficulty"] as? String
        
        let user = job["userPosted"] as! PFUser
        usernameLabel.text = user.username!
        
        //date posted
        let date = job["dateDue"]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from:date as! Date)
        datePostedLabel.text = dateString //as! String
        
        descriptionLabel.text = job["description"] as? String ?? ""
        
        let a:Double = job["pay"] as! Double
        let b:String = String(format:"%.2f", a)
        costLabel.text = "$" + b
        
        let skills = job["tags"] as! [String]
        for skill in skills {
            skillsLabel.text = skill + ", "
        }
        
        let latitude = job["latitude"] as! CLLocationDegrees
        let longitude = job["longitude"] as! CLLocationDegrees
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotation = Job(title: job["title"] as? String, subtitle: job["description"] as? String, location: coordinate)
        mapView.addAnnotation(annotation)
//        centerMapOnLocation(location: CLLocation(latitude: latitude, longitude: longitude))
        
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
    
    func centerMapOnLocation(firstCoordinate: CLLocationCoordinate2D, secondCoordinate: CLLocationCoordinate2D) {
        let newLatitude = (firstCoordinate.latitude + secondCoordinate.latitude)/2
        let newLongitude = (firstCoordinate.longitude + secondCoordinate.longitude)/2
        let newLocation = CLLocation(latitude: newLatitude, longitude: newLongitude)
        
        let firstLocation = CLLocation(latitude: firstCoordinate.latitude, longitude: firstCoordinate.longitude)
        let secondLocation = CLLocation(latitude: secondCoordinate.latitude, longitude: secondCoordinate.longitude)
        let distance = firstLocation.distance(from: secondLocation)
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, distance, distance)
        mapView.setRegion(coordinateRegion, animated: false)
        
    }
    
}

extension DetailViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if initialLocation == nil {
            initialLocation = userLocation
            let jobCoordinate = CLLocationCoordinate2D(latitude: job["latitude"] as! CLLocationDegrees, longitude: job["longitude"] as! CLLocationDegrees)
            centerMapOnLocation(firstCoordinate: userLocation.coordinate, secondCoordinate: jobCoordinate)
        }
    }
}

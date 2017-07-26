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
    
    @IBOutlet weak var jobPostPFImageView: PFImageView!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var dificultyLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var datePostedLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var skillsLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var job: PFObject!
    var initialLocation: MKUserLocation?
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestLocationAccess()
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.isZoomEnabled = false
        mapView.isPitchEnabled = false
        mapView.isScrollEnabled = false
        mapView.isRotateEnabled = false
        
        jobPostPFImageView.file = job["image"] as? PFFile
        jobPostPFImageView.loadInBackground()
        
        let user = job["userPosted"] as! PFUser
        let date = job["dateDue"]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from:date as! Date)
        let pay = job["pay"] as! Double
        let payString = String(format:"%.2f", pay)
        
        usernameLabel.text = user.username!
        jobTitleLabel.text = job["title"] as? String
        dificultyLabel.text = job["difficulty"] as? String
        descriptionLabel.text = job["description"] as? String ?? ""
        datePostedLabel.text = dateString
        costLabel.text = "$" + payString
        
        
        let skills = job["tags"] as! [String]
        print(skills)
        
        for (index, element) in skills.enumerated() {
            //prints the word skills appended to the first ?
            skillsLabel.text = skillsLabel.text! + element
            if (index < skills.count - 1) {
                skillsLabel.text = skillsLabel.text! + ", "
            }
        }
        
        
        let latitude = job["latitude"] as! CLLocationDegrees
        let longitude = job["longitude"] as! CLLocationDegrees
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotation = Job(title: job["title"] as? String, subtitle: job["description"] as? String, location: coordinate)
        mapView.addAnnotation(annotation)
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
            if usersInterested.contains(currentUser!){
                hasAlreadyAppliedAlert()
            } else {
            usersInterested.append(currentUser!)
            self.job["usersInterested"] = usersInterested
            self.job.saveInBackground().continue({ (task:BFTask<NSNumber>) -> Any? in
                self.saveUserData()
                 })
            }}
        
        
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
        let alert = UIAlertController(title: "Job request sent!", message: "Nice work. You've successfully applied to this job. A notification will be sent to the job poster. Thank you for you interest.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func hasAlreadyAppliedAlert() {
        let alert = UIAlertController(title: "Whoops!", message: "Looks like you've already applied to this job. Don't worry about it.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Got it", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    

    
    @IBAction func requestJob(_ sender: UIBarButtonItem) {
        savejobData()
        
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

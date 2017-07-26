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
    
    @IBOutlet weak var jobPosterPFImage: PFImageView!
    @IBOutlet weak var jobPostPFImageView: PFImageView!
    @IBOutlet weak var jobTitleLabel: UILabel!
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
        
        let user = job["userPosted"] as! PFUser
        let date = job["dateDue"]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from:date as! Date)
        let pay = job["pay"] as! Double
        let payString = String(format:"%.2f", pay)
        
        jobPosterPFImage.file = user["profilePicture"] as? PFFile
        jobPosterPFImage.layer.cornerRadius = jobPosterPFImage.frame.size.width/2
        jobPosterPFImage.layer.masksToBounds = true
        jobPosterPFImage.loadInBackground()
        
        jobPostPFImageView.file = job["image"] as? PFFile
        jobPostPFImageView.loadInBackground()
        
        usernameLabel.text = user.username!
        jobTitleLabel.text = job["title"] as? String
        descriptionLabel.text = job["description"] as? String ?? ""
        datePostedLabel.text = dateString
        costLabel.text = "$" + payString
        
        
        let skills = job["tags"] as! [String]
        print(skills)
        
        skillsLabel.text = ""
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
        
        print("height of skills label")
        print(skillsLabel.frame.height)
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
    
    @IBAction func requestJob(_ sender: UIBarButtonItem) {
        let currentUser = PFUser.current()
        var successfullyApplied: Bool = true
        
        if job["usersInterested"] == nil{
            var usersInterested: [PFUser]! = []
            usersInterested.append(currentUser!)
            job["usersInterested"] = usersInterested!
            print("user saved!")
            job.saveInBackground()
        } else {
            var usersInterested = job["usersInterested"] as! [PFUser]
            usersInterested.append(currentUser!)
            job["usersInterested"] = usersInterested
            job.saveInBackground()
        }
        
        if currentUser?["jobsInterested"] == nil {
            var jobsInterested: [PFObject] = []
            jobsInterested.append(job)
            currentUser?["jobsInterested"] = jobsInterested
            currentUser?.saveInBackground()
            print("saved interested job")
        } else {
            var jobsInterested = currentUser?["jobsInterested"] as! [PFObject]
            jobsInterested.append(job)
            currentUser?["jobsInterested"] = jobsInterested
            currentUser?.saveInBackground()
            print("saved interested job")
        }
        
        if (successfullyApplied) {
            let alert = UIAlertController(title: "Congratulations!", message: "Nice work. You've successfully applies to this job. A notification will be sent to the job poster. Thanks you for you interest.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "You're welcome :)", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Whoops!", message: "Looks like you've already applied to this job. Don't worry about it.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Got it", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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

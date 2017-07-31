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
    
    @IBOutlet var totalView: UIView!
    @IBOutlet weak var jobPosterPFImage: PFImageView!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var datePostedLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var skillsLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var backgroundCard: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    
    var job: PFObject!
    var initialLocation: MKUserLocation?
    var chatRoom: PFObject!
    var justApplied: Bool?
    let locationManager = CLLocationManager()
    let color = ColorObject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        requestLocationAccess()
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.isZoomEnabled = false
        mapView.isPitchEnabled = false
        mapView.isScrollEnabled = false
        mapView.isRotateEnabled = false
        
        self.totalView.backgroundColor = color.myRedColor
        
        self.backgroundCard.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        self.backgroundCard.layer.cornerRadius = 3.0
        self.backgroundCard.layer.masksToBounds = false
        self.backgroundCard.layer.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5).cgColor
        self.backgroundCard.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.backgroundCard.layer.shadowOpacity = 0.8
        
        
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
        
    
        
        usernameLabel.text = user.username!
        jobTitleLabel.text = job["title"] as? String
        
        descriptionLabel.layer.cornerRadius = 3.0
        descriptionLabel.layer.masksToBounds = true
        descriptionLabel.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        descriptionLabel.text = job["description"] as? String ?? ""
        datePostedLabel.text = dateString
        costLabel.text = "$" + payString
        
        locationLabel.text = "Location: " + (job["address"] as? String ?? "")
        
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
        
        
        let latitude = (job["location"] as! PFGeoPoint).latitude as! CLLocationDegrees
        let longitude = (job["location"] as! PFGeoPoint).longitude as! CLLocationDegrees
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotation = Job(title: job["title"] as? String, subtitle: job["description"] as? String, location: coordinate)
        mapView.addAnnotation(annotation)
        
        print("height of skills label")
        print(skillsLabel.frame.height)
        
        if justApplied == true {
            requestSentAlert()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "applySegue" {
            let nav = segue.destination as! UINavigationController
            let vc = nav.topViewController! as! FirstMessageViewController
            vc.chatRoom = chatRoom
            vc.job = job
        }
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
    
    func requestSentAlert() {
        let alert = UIAlertController(title: "Job request sent!", message: "Nice work. You've successfully applied to this job. A notification will be sent to the job poster. Thank you for you interest.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func hasAlreadyAppliedAlert() {
        let alert = UIAlertController(title: "Whoops!", message: "Looks like you've already applied to this job. Don't worry about it.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Got it", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func requestJob(_ sender: UIBarButtonItem) {
        let poster = job["userPosted"] as! PFUser
        if PFUser.current()!.objectId! != poster.objectId! {
            let usersInterested = job["usersInterested"] as? [PFUser] ?? []
            if usersInterested.contains(PFUser.current()!) {
                hasAlreadyAppliedAlert()
            } else {
//                savejobData()
                chatRoom = ChatRoom.createChatRoom(firstUser: PFUser.current()!, secondUser: job["userPosted"] as! PFUser, job: job, completion: { (success: Bool, error: Error?) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("chat room created")
                    }
                })
                performSegue(withIdentifier: "applySegue", sender: nil)
            }
        } else {
            let alert = UIAlertController(title: "Whoops!", message: "You can't apply to your own job!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
}

extension DetailViewController: MKMapViewDelegate {
    
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
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if initialLocation == nil {
            initialLocation = userLocation
            let jobCoordinate = CLLocationCoordinate2D(latitude: (job["location"] as! PFGeoPoint).latitude as! CLLocationDegrees, longitude: (job["location"] as! PFGeoPoint).longitude as! CLLocationDegrees)
            centerMapOnLocation(firstCoordinate: userLocation.coordinate, secondCoordinate: jobCoordinate)
        }
    }
}

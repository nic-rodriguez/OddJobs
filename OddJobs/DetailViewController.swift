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
    let regionRadius: CLLocationDistance = 1000
    
    @IBOutlet weak var jobPostPFImageView: PFImageView!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var dificultyLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var datePostedLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var skillsLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
//        let pay = job["pay"] as? String
//        costLabel.text = "$" + pay!
        
        let skills = job["tags"] as! [String]
        for skill in skills {
            skillsLabel.text = skill + ", "
        }
        
        let latitude = job["latitude"] as! CLLocationDegrees
        let longitude = job["longitude"] as! CLLocationDegrees
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotation = Job(title: job["title"] as? String, subtitle: job["description"] as? String, location: coordinate)
        mapView.addAnnotation(annotation)
        centerMapOnLocation(location: CLLocation(latitude: latitude, longitude: longitude))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius*2, regionRadius*2)
        mapView.setRegion(coordinateRegion, animated: false)
        
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

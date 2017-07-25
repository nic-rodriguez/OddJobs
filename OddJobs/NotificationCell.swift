//
//  NotificationCell.swift
//  OddJobs
//
//  Created by Pavani Malli on 7/18/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import Parse

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userDistanceLabel: UILabel!

    var userInterested: PFUser!{
        didSet {
            self.loadUserData()
        }
    }

    var correspondingJob: PFObject!{
        didSet {
            self.loadJobData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func loadUserData() {
        
        usernameLabel.text = userInterested.username as? String ?? "error"
        
        
        let location = self.userInterested["location"] as? PFGeoPoint
        var currentUserLocation: PFGeoPoint!
        
        PFGeoPoint.geoPointForCurrentLocation(inBackground: { (geoPoint: PFGeoPoint!, error:Error?) in
            if geoPoint != nil {
                let geoPointLat = geoPoint.latitude
                let geoPointLong = geoPoint.longitude
                currentUserLocation = PFGeoPoint(latitude: geoPointLat, longitude: geoPointLong)
                self.userDistanceLabel.text = String(format: "%.0f", currentUserLocation.distanceInMiles(to: location)) + " mi away"
            } else {
                print(error?.localizedDescription ?? "Error")
            }
        })
        
        
        
    }
    
    func loadJobData() {
        jobTitleLabel.text = correspondingJob["title"] as! String
               
    }

}

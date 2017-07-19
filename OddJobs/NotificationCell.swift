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
    
    var userInterested: PFUser!{
        didSet {
            self.loadUserData()
        }
    }

    var correspondingJob: PFObject!{
        didSet {
            self.loadJobData()
            print("did set ho")
        }
    }

    
    
    @IBOutlet weak var jobTitleLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var userDistanceLabel: UILabel!
    
    @IBOutlet weak var userRatingLabel: UILabel!
    
   
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func loadUserData() {
                
    
    
        
        usernameLabel.text = userInterested.username as? String ?? "error"
        print(usernameLabel.text)
        
        let location = self.userInterested["location"] as? PFGeoPoint
        let currentUserLocation = PFUser.current()?["location"] as! PFGeoPoint
        
        userDistanceLabel.text = String(format: "%.0f", currentUserLocation.distanceInMiles(to: location)) + " mi away"
        
    }
    
    func loadJobData() {
        print("is setting")
        jobTitleLabel.text = correspondingJob["title"] as! String
               
    }

}

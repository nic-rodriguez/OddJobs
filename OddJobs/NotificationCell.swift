//
//  NotificationCell.swift
//  OddJobs
//
//  Created by Pavani Malli on 7/18/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import Parse

protocol notificationCellDelegate: class {
    func callSegueFromCell(userID: String, cellIndex: Int)
}

class NotificationCell: UITableViewCell {
    
    weak var delegate: notificationCellDelegate?
    
    var cellIndex: Int!
    
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

    
    @IBOutlet weak var jobTitleLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var userDistanceLabel: UILabel!
    
    @IBOutlet weak var messageButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func messageUser(_ sender: Any) {
        let userInterestedId = userInterested.username as! String
        
        self.delegate?.callSegueFromCell(userID: userInterestedId, cellIndex: self.cellIndex)
        
    }
    
    
 
    
    func loadUserData() {
   
        usernameLabel.text = userInterested.username as? String ?? "error"
        
        
        let location = self.userInterested["location"] as? PFGeoPoint
        let currentUserLocation = PFUser.current()?["location"] as! PFGeoPoint
        
        userDistanceLabel.text = String(format: "%.0f", currentUserLocation.distanceInMiles(to: location)) + " mi away"
        
    }
    
    func loadJobData() {
        jobTitleLabel.text = correspondingJob["title"] as! String
               
    }

}

//
//  WorkersTableViewCell.swift
//  OddJobs
//
//  Created by Pavani Malli on 7/17/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class WorkersTableViewCell: UITableViewCell {
    var currentUser = PFUser.current()
    
    var currentUserLocation: PFGeoPoint! {
        didSet {
            self.loadData()
        }
    }
    
    var user: PFUser!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var profileImageView: PFImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var distanceFromLabel: UILabel!
    
    func loadData() {
        nameLabel.text = user.username
        self.profileImageView.file = user["profilePicture"] as? PFFile
        self.profileImageView.loadInBackground()
        //descriptionLabel.text = user["bio"]
        let location = user["location"] as? PFGeoPoint
        let currentUserLocation = currentUser?["homeLocation"] as! PFGeoPoint
        
        distanceFromLabel.text = String(format: "%.0f", self.currentUserLocation.distanceInMiles(to: location)) + " mi away"
        
    
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

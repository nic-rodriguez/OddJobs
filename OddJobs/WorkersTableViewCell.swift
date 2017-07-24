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
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var profileImageView: PFImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var distanceFromLabel: UILabel!
    
    var currentUser = PFUser.current()
    
    var currentUserLocation: PFGeoPoint! {
        didSet {
            self.loadData()
        }
    }
    
    var user: PFUser!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func loadData() {
        nameLabel.text = user.username
        self.profileImageView.file = user["profilePicture"] as? PFFile
        self.profileImageView.loadInBackground()
        descriptionLabel.text = user["bio"] as? String ?? ""
        let location = user["homeLocation"] as? PFGeoPoint
        print(self.currentUserLocation)
        
        distanceFromLabel.text = String(format: "%.0f", self.currentUserLocation.distanceInMiles(to: location)) + " mi away"
    }


}

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
    
    @IBOutlet weak var skillsLabel: UILabel!
    
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
        self.profileImageView.layer.borderWidth=1.0
        self.profileImageView.layer.borderColor = UIColor.white.cgColor
        self.profileImageView.layer.masksToBounds = false
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2
        self.profileImageView.clipsToBounds = true
        self.profileImageView.loadInBackground()
        descriptionLabel.text = user["bio"] as? String ?? ""
        
        let skills = user["skills"] as! [String]
    
        if skills.count != 0 {
        skillsLabel.text = "Skills: "}
        
        for (index, element) in skills.enumerated() {
            //prints the word skills appended to the first ?
            skillsLabel.text = skillsLabel.text! + element
            if (index < skills.count - 1) {
                skillsLabel.text = skillsLabel.text! + ", "
            }
        }

    
        let location = user["homeLocation"] as? PFGeoPoint
        print(self.currentUserLocation)
        
        distanceFromLabel.text = String(format: "%.0f", self.currentUserLocation.distanceInMiles(to: location)) + " mi away"
    }


}

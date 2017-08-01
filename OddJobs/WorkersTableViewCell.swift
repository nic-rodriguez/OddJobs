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
    @IBOutlet weak var backgroundCardView: UIView!
    
    var currentUser = PFUser.current()
    let color = ColorObject()
    
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
        backgroundCardView.backgroundColor = color.myLightColor
        backgroundCardView.layer.cornerRadius = 10.0
        backgroundCardView.layer.masksToBounds = false
        backgroundCardView.layer.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5).cgColor
        backgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundCardView.layer.shadowOpacity = 0.4
        contentView.backgroundColor = color.myRedColor
        
        
        nameLabel.text = user.username
        self.profileImageView.file = user["profilePicture"] as? PFFile
        self.profileImageView.layer.borderWidth=1.0
        self.profileImageView.layer.borderColor = UIColor.white.cgColor
        self.profileImageView.layer.masksToBounds = false
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2
        self.profileImageView.clipsToBounds = true
        self.profileImageView.loadInBackground()
        descriptionLabel.text = user["bio"] as? String ?? ""
        
        skillsLabel.text = ""
        let skills = user["skills"] as! [String]
        if skills.count != 0 {
            skillsLabel.text = "Skills: "
        }
        for (index, element) in skills.enumerated() {
            skillsLabel.text = skillsLabel.text! + element
            if (index < skills.count - 1) {
                skillsLabel.text = skillsLabel.text! + ", "
            }
        }
    
        let location = user["homeLocation"] as? PFGeoPoint
        print(self.currentUserLocation)
        
        distanceFromLabel.text = String(format: "%.0f", self.currentUserLocation.distanceInMiles(to: location)) + " mi away"
        
        nameLabel.textColor = color.myDarkColor
        distanceFromLabel.textColor = color.myDarkColor
        descriptionLabel.textColor = color.myDarkColor
        skillsLabel.textColor = color.myDarkColor
        
    }
    
}

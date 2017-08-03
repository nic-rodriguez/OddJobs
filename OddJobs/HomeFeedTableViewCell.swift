//
//  HomeFeedTableViewCell.swift
//  OddJobs
//
//  Created by Nicolas Rodriguez on 7/12/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class HomeFeedTableViewCell: UITableViewCell {
  
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImageView: PFImageView?
    @IBOutlet weak var userImageView: PFImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var backgroundCardView: UIView!
    
    var currentUser = PFUser.current()
    let color = ColorObject()
    
    var job: PFObject! {
        didSet {
            self.postImageView?.file = job["image"] as? PFFile
            self.postImageView?.loadInBackground()
            
            let jobPoster = job["userPosted"] as! PFUser
            self.userImageView.file = jobPoster["profilePicture"] as? PFFile
            self.userImageView.layer.borderWidth=1.0
            self.userImageView.layer.borderColor = UIColor.white.cgColor
            self.userImageView.layer.masksToBounds = false
            self.userImageView.layer.cornerRadius = self.userImageView.frame.size.height/2
            self.userImageView.clipsToBounds = true
            self.userImageView.loadInBackground()
            
            self.usernameLabel.text = jobPoster.username
            
            self.titleLabel.text = job["title"] as? String
            self.descriptionLabel.text = job["description"] as? String
            
            
            let a:Double = job["pay"] as! Double
            let b:String = String(format:"%.2f", a)
            self.costLabel.text = "$" + b
            
            let descLocation: PFGeoPoint = job["location"] as! PFGeoPoint
            var currentUserLocation: PFGeoPoint!
            PFGeoPoint.geoPointForCurrentLocation(inBackground: { (geoPoint: PFGeoPoint!, error:Error?) in
                if geoPoint != nil {
                    let geoPointLat = geoPoint.latitude
                    let geoPointLong = geoPoint.longitude
                    currentUserLocation = PFGeoPoint(latitude: geoPointLat, longitude: geoPointLong)
                    self.distanceLabel.text = String(format: "%.0f", currentUserLocation.distanceInMiles(to: descLocation)) + " mi away"
                    
                } else{
                    print(error?.localizedDescription ?? "Error")
                }
            })
            
            costLabel.textColor = color.myTealColor
            titleLabel.textColor = color.myDarkColor
            distanceLabel.textColor = color.myTealColor
            descriptionLabel.textColor = color.myDarkColor
            contentView.backgroundColor = color.myRedColor
            self.backgroundCardView.backgroundColor = color.myLightColor
            self.backgroundCardView.layer.cornerRadius = 3.0
            self.backgroundCardView.layer.masksToBounds = false
            self.backgroundCardView.layer.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5).cgColor
            self.backgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.backgroundCardView.layer.shadowOpacity = 0.4
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

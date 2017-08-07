//
//  PendingJobsCell.swift
//  OddJobs
//
//  Created by Pavani Malli on 7/19/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import Parse
import ParseUI

@objc protocol PendingJobsCellDelegate {
    func queryChatRooms(pendingCell: PendingJobsCell, job: PFObject, firstUser: PFUser, secondUser: PFUser)
}

class PendingJobsCell: UITableViewCell {

  
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var userProfileImage: PFImageView!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var userPostedLabel: UILabel!
    @IBOutlet weak var datePostedLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var backgroundCard: UIView!
    
    var jobInterested: PFObject!{
        didSet {
            self.loadJobData()
        }
    }
    
    var userPosted: PFUser!{
        didSet {
            self.fetchUserData()
        }
    }
    
    var chatRoom: PFObject?
    
    var delegate: PendingJobsCellDelegate?
    
    let color = ColorObject()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundCard.backgroundColor = color.myLightColor
        self.backgroundCard.layer.cornerRadius = 3.0
        self.backgroundCard.layer.masksToBounds = false
        self.backgroundCard.layer.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5).cgColor
        self.backgroundCard.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.backgroundCard.layer.shadowOpacity = 0.8
        
        contentView.backgroundColor = color.myTealColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func loadJobData() {
        jobTitleLabel.text = jobInterested["title"] as! String
    
        
        let date = jobInterested["dateDue"]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E MMM d, h:mm a"
        let dateString = dateFormatter.string(from:date as! Date)
        datePostedLabel.text = (dateString as! String)
        
        let a:Double = jobInterested["pay"] as! Double
        let b:String = String(format:"%.2f", a)
        self.costLabel.text = "$" + b
        
        
        var currentUserLocation: PFGeoPoint!
        PFGeoPoint.geoPointForCurrentLocation(inBackground: { (geoPoint: PFGeoPoint!, error:Error?) in
            if geoPoint != nil {
                let geoPointLat = geoPoint.latitude
                let geoPointLong = geoPoint.longitude
                currentUserLocation = PFGeoPoint(latitude: geoPointLat, longitude: geoPointLong)
                self.distanceLabel.text = String(format: "%.0f", currentUserLocation.distanceInMiles(to: (self.jobInterested["location"] as! PFGeoPoint))) + " mi away"
            } else {
                print(error?.localizedDescription ?? "Error")
            }
        })
    
    }
    
    
    
    func fetchUserData(){
        
        let query = PFQuery(className: "_User")
        query.includeKey("_User")
        query.includeKey("username")
       
        //Need to load profile picture
        print("starting query")
        
        query.getObjectInBackground(withId: self.userPosted.objectId!) { (user: PFObject?, error:Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.userPostedLabel.text = user?["username"] as! String
                self.userProfileImage.file = user?["profilePicture"] as? PFFile
                self.userProfileImage.layer.borderWidth=1.0
                self.userProfileImage.layer.borderColor = UIColor.white.cgColor
                self.userProfileImage.layer.masksToBounds = false
                self.userProfileImage.layer.cornerRadius = self.userProfileImage.frame.size.height/2
                self.userProfileImage.clipsToBounds = true
                self.userProfileImage.loadInBackground()
                
               

                
            }
        }
        
    }
    
    
    @IBAction func checkMessages(_ sender: Any) {
        delegate!.queryChatRooms(pendingCell: self, job: jobInterested, firstUser: userPosted, secondUser: PFUser.current()!)
    }
    

}

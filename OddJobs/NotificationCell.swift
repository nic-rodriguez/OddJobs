//
//  NotificationCell.swift
//  OddJobs
//
//  Created by Pavani Malli on 7/18/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import Parse
import ParseUI


@objc protocol NotificationCellDelegate {
    func queryChatRooms(notificationCell: NotificationCell, job: PFObject, firstUser: PFUser, secondUser: PFUser)
    func acceptUser(userInterested: PFUser, cellIndex: Int)
    func declineUser(userInterested: PFUser, cellIndex: Int)
}

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var userProfileImage: PFImageView!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userDistanceLabel: UILabel!
    @IBOutlet weak var backgroundCard: UIView!
    @IBOutlet weak var acceptedButton: UIButton!
    @IBOutlet weak var declinedButton: UIButton!
    
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
    
    var chatRoom: PFObject?
    var cellIndex: Int!
    var delegate: NotificationCellDelegate?
    
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
    
    
    func loadUserData() {
        usernameLabel.text = userInterested.username ?? "error"
        
        self.userProfileImage.file = userInterested["profilePicture"] as? PFFile
        self.userProfileImage.layer.borderWidth=1.0
        self.userProfileImage.layer.borderColor = UIColor.white.cgColor
        self.userProfileImage.layer.masksToBounds = false
        self.userProfileImage.layer.cornerRadius = self.userProfileImage.frame.size.height/2
        self.userProfileImage.clipsToBounds = true
        self.userProfileImage.loadInBackground()
        
        let location = self.userInterested["homeLocation"] as? PFGeoPoint
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
        jobTitleLabel.text = correspondingJob["title"] as? String
               
    }
    
    @IBAction func messagePress(_ sender: Any) {
        delegate!.queryChatRooms(notificationCell: self, job: correspondingJob, firstUser: PFUser.current()!, secondUser: userInterested)
    }
    
    @IBAction func acceptUser(_ sender: UIButton) {
        delegate?.acceptUser(userInterested: userInterested, cellIndex: cellIndex)
        
        sender.isSelected = !sender.isSelected
        if (acceptedButton.isSelected) {
            acceptedButton.backgroundColor = color.myRedColor
            acceptedButton.setTitleColor(color.myLightColor, for: .selected)
            acceptedButton.setTitleColor(color.myLightColor, for: .disabled)
        } else {
            acceptedButton.backgroundColor = color.myLightColor
        }
        
    }
    
    @IBAction func declineUser(_ sender: UIButton) {
        delegate!.declineUser(userInterested: userInterested, cellIndex: cellIndex)
        
//        sender.isSelected = !sender.isSelected
//        if (declinedButton.isSelected) {
//            declinedButton.backgroundColor = color.myRedColor
//        } else {
//            declinedButton.backgroundColor = color.myLightColor
//        }
    }
}

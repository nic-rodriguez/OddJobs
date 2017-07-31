//
//  NotificationCell.swift
//  OddJobs
//
//  Created by Pavani Malli on 7/18/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import Parse

@objc protocol NotificationCellDelegate {
    func queryChatRooms(notificationCell: NotificationCell, job: PFObject, firstUser: PFUser, secondUser: PFUser)
    
    func acceptUser(userInterested: PFUser, cellIndex: Int)
}

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
    var chatRoom: PFObject?
    var cellIndex: Int!
    var delegate: NotificationCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func loadUserData() {
        usernameLabel.text = userInterested.username ?? "error"
        
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
        jobTitleLabel.text = correspondingJob["title"] as? String
               
    }
    
    
    @IBAction func messagePress(_ sender: Any) {
        delegate!.queryChatRooms(notificationCell: self, job: correspondingJob, firstUser: PFUser.current()!, secondUser: userInterested)
    }
    
    
    @IBAction func acceptUser(_ sender: UIButton) {
        delegate?.acceptUser(userInterested: userInterested, cellIndex: cellIndex)
    }

}

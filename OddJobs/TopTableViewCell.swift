//
//  TopTableViewCell.swift
//  OddJobs
//
//  Created by Melody Ann Seda Marotte on 7/12/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class TopTableViewCell: UITableViewCell {

    var user: PFUser!
    
    @IBOutlet weak var backgroundProfilePFImage: PFImageView?
    
    @IBOutlet weak var profilePFImage: PFImageView?
    @IBOutlet weak var usernameLabel: UILabel?
    @IBOutlet weak var ratingLabel: UILabel?
    @IBOutlet weak var bioLabel: UILabel?
    @IBOutlet weak var jobsTakenCounterLabel: UILabel?
    @IBOutlet weak var jobsPosterCounterLabel: UILabel?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //let user = PFUser.current()!
        
//        if (user == nil) {
            user = PFUser.current()
//        }
        
        backgroundProfilePFImage?.file = user["backgroundImage"] as? PFFile
        backgroundProfilePFImage?.loadInBackground()
        
        profilePFImage?.file = user["profilePicture"] as? PFFile
        profilePFImage?.loadInBackground()
        
//        cell.userImageView.layer.cornerRadius = cell.userImageView.frame.size.width/2
//        cell.userImageView.layer.masksToBounds = true
        
        usernameLabel?.text = PFUser.current()?.username!
        
//        usernameLabel.text = user["author"] as! String
        
        
        ratingLabel?.text = user["rating"] as? String
        bioLabel?.text = user["bio"] as? String
        jobsTakenCounterLabel?.text = user["jobsTakenInt"] as? String
        jobsPosterCounterLabel?.text = user["jobsPostedInt"] as? String
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

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

protocol TopTableViewDelegate: class {
    func topTableViewCell(_ topTableViewCell: TopTableViewCell)
}

class TopTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backgroundProfilePFImage: PFImageView?
    @IBOutlet weak var profilePFImage: PFImageView?
    @IBOutlet weak var usernameLabel: UILabel?
    @IBOutlet weak var ratingLabel: UILabel?
    @IBOutlet weak var bioLabel: UILabel?
    @IBOutlet weak var jobsTakenCounterLabel: UILabel?
    @IBOutlet weak var jobsPosterCounterLabel: UILabel?
    
    var user: PFUser!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        loadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func loadData() {
        if (user == nil) {
            user = PFUser.current()
        }
        
        backgroundProfilePFImage?.file = user["backgroundImage"] as? PFFile
        backgroundProfilePFImage?.loadInBackground()
        
        profilePFImage?.file = user["profilePicture"] as? PFFile
        profilePFImage?.loadInBackground()
        
        usernameLabel?.text = user?.username!
        
        ratingLabel?.text = user["rating"] as? String ?? "0"
        bioLabel?.text = user["bio"] as? String ?? ""
        jobsTakenCounterLabel?.text = user["jobsTakenInt"] as? String ?? "0"
        jobsPosterCounterLabel?.text = user["jobsPostedInt"] as? String ?? "0"
        
    }
    
}

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
    
    @IBOutlet weak var profilePFImage: PFImageView?
    @IBOutlet weak var usernameLabel: UILabel?
    @IBOutlet weak var ratingLabel: UILabel?
    @IBOutlet weak var bioLabel: UILabel?
    @IBOutlet weak var skillsLabel: UILabel!
    @IBOutlet weak var jobsTakenCounterLabel: UILabel?
    @IBOutlet weak var jobsPosterCounterLabel: UILabel?
    @IBOutlet weak var topProfileCardView: UIView!
    @IBOutlet weak var jobPostedLabel: UILabel!
    @IBOutlet weak var jobTakenLabel: UILabel!
    
    let color = ColorObject()
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
        
        profilePFImage?.file = user["profilePicture"] as? PFFile
        profilePFImage?.loadInBackground()
        
        usernameLabel?.text = user?.username!
        ratingLabel?.text = user["rating"] as? String ?? "0"
        bioLabel?.text = user["bio"] as? String ?? ""
        jobsTakenCounterLabel?.text = user["jobsTakenInt"] as? String ?? "0"
        jobsPosterCounterLabel?.text = user["jobsPostedInt"] as? String ?? "0"
        
        profilePFImage?.layer.cornerRadius = (profilePFImage?.frame.size.width)!/2
        profilePFImage?.layer.masksToBounds = true
        
        skillsLabel?.text = ""
        let skills = user["skills"] as! [String]
        if skills.count != 0 {
            skillsLabel?.text = "Skills: "
        }
        for (index, element) in skills.enumerated() {
            skillsLabel?.text = (skillsLabel?.text!)! + element
            if (index < skills.count - 1) {
                skillsLabel?.text = (skillsLabel?.text!)! + ", "
            }
        }
        
        
        
        usernameLabel?.textColor = color.myDarkColor
        ratingLabel?.textColor = color.myRedColor
        bioLabel?.textColor = color.myDarkColor
        skillsLabel?.textColor = color.myDarkColor
        
        jobsPosterCounterLabel?.textColor = color.myDarkColor
        jobPostedLabel?.textColor = color.myRedColor
        jobsTakenCounterLabel?.textColor = color.myDarkColor
        jobTakenLabel?.textColor = color.myRedColor
        
        contentView.backgroundColor = color.myTealColor
        
    }
    
}

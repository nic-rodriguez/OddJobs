//
//  PendingJobsCell.swift
//  OddJobs
//
//  Created by Pavani Malli on 7/19/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import Parse

class PendingJobsCell: UITableViewCell {

    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var userPostedLabel: UILabel!
    @IBOutlet weak var datePostedLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var jobInterested: PFObject!{
        didSet {
            self.loadJobData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
<<<<<<< HEAD
=======
        // Configure the view for the selected state
>>>>>>> a71460c62bc7a3301932f7492040c8ed97b158c7
    }
    
    func loadJobData() {
        jobTitleLabel.text = jobInterested["title"] as! String
        descriptionLabel.text = jobInterested["description"] as! String
<<<<<<< HEAD
        
        let date = jobInterested["dateDue"]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from:date as! Date)
        datePostedLabel.text = dateString as! String
        
        let userPosted = jobInterested["userPosted"] as! PFUser
        userPostedLabel.text = userPosted.username as! String
=======
        //datePostedLabel.text = jobInterested["dateDue"] as! String
        //userPostedLabel.text = jobInterested["userPosted"]["username"] as! String
>>>>>>> a71460c62bc7a3301932f7492040c8ed97b158c7
    }

}

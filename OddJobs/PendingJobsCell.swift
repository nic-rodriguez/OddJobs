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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadJobData() {
        jobTitleLabel.text = jobInterested["title"] as! String
        descriptionLabel.text = jobInterested["description"] as! String
        //datePostedLabel.text = jobInterested["dateDue"] as! String
        //userPostedLabel.text = jobInterested["userPosted"]["username"] as! String

        
    }

}

//
//  UserJobsTableViewCell.swift
//  OddJobs
//
//  Created by Melody Ann Seda Marotte on 7/12/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class UserJobsTableViewCell: UITableViewCell {

    var job: Job!
    
    @IBOutlet weak var jobPFImage: PFImageView!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var jobDateLabel: UILabel!      //might have conflict, like what if ur getting date posted or date completed
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        jobPFImage.file = user["jobImage"] as? PFFile
//        jobPFImage.loadInBackground()
        
        jobTitleLabel.text = job["title"]
        
        //date posted
        let date = post["dateDue"]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from:date as! Date)
        jobDateLabel.text = dateString as! String
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

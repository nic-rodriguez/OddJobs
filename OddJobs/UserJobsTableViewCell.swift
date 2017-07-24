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
    
    @IBOutlet weak var jobPFImage: PFImageView!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var jobDateLabel: UILabel!

    var job: PFObject! {
        didSet {

            jobTitleLabel.text = job["title"] as? String

            let date = job["dateDue"]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from:date as! Date)
            jobDateLabel.text = dateString as! String
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

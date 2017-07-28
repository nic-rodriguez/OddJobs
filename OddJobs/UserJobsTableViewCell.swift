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
    
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var jobDateLabel: UILabel!
    @IBOutlet weak var backgroundCardView: UIView!

    let color = ColorObject()
    
    var job: PFObject! {
        didSet {

            jobTitleLabel.text = job["title"] as? String

            let date = job["dateDue"]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from:date as! Date)
            jobDateLabel.text = dateString as! String
            
            jobTitleLabel.textColor = color.myDarkColor
            jobDateLabel.textColor = color.myTealColor
            contentView.backgroundColor = color.myRedColor //myColor
            self.backgroundCardView.backgroundColor = color.myLightColor
            self.backgroundCardView.layer.cornerRadius = 3.0
            self.backgroundCardView.layer.masksToBounds = false
            self.backgroundCardView.layer.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5).cgColor
            self.backgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.backgroundCardView.layer.shadowOpacity = 0.8
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

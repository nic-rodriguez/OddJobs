//
//  HomeFeedTableViewCell.swift
//  OddJobs
//
//  Created by Nicolas Rodriguez on 7/12/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class HomeFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var postImageView: PFImageView?
    @IBOutlet weak var userImageView: PFImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var job: PFObject! {
        didSet {
            self.postImageView?.file = job["image"] as? PFFile
            self.postImageView?.loadInBackground()
            
            let jobPoster = job["userPosted"] as! PFUser
            
            
//            print(jobPoster["PFUser"])
//            self.userImageView.file = jobPoster["profilePic"] as? PFFile
//            self.userImageView.loadInBackground()
//            print(jobPoster["PFUser"].username)
            
            self.nameLabel.text = jobPoster.username!
            self.titleLabel.text = job["title"] as? String
            self.dateLabel.text = job["dateDue"] as? String
//            self.costLabel.text = job["pay"] as? String
            let a:Double = job["pay"] as! Double
            let b:String = String(format:"%.2f", a)
            self.costLabel.text = "$" + b

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

}

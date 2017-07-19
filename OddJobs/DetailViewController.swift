//
//  DetailViewController.swift
//  OddJobs
//
//  Created by Melody Ann Seda Marotte on 7/17/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class DetailViewController: UIViewController {
    
    var job: PFObject!
    
    @IBOutlet weak var jobPostPFImageView: PFImageView!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var dificultyLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var datePostedLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var skillsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jobPostPFImageView.file = job["image"] as! PFFile
        jobPostPFImageView.loadInBackground()
        
        jobTitleLabel.text = job["title"] as? String
        
        dificultyLabel.text = job["difficulty"] as? String
        
        let user = job["userPosted"] as! PFUser
        usernameLabel.text = user.username!
        
        //date posted
        let date = job["dateDue"]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from:date as! Date)
        datePostedLabel.text = dateString //as! String
        
        descriptionLabel.text = job["description"] as? String ?? ""
        
        let a:Double = job["pay"] as! Double
        let b:String = String(format:"%.2f", a)
        costLabel.text = "$" + b
        
        let skills = job["tags"] as! [String]
        for skill in skills {
            skillsLabel.text = skill + ", "
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

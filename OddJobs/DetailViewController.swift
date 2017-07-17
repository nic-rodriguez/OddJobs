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
    
    var job: PFObject! {
        didSet {
            
            //image
            
            jobTitleLabel.text = job["title"] as? String
            
            dificultyLabel.text = job["difficulty"] as? String
            
            usernameLabel.text = job["userPosted"] as? String
            
            //date posted
            let date = job["dateDue"]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from:date as! Date)
            datePostedLabel.text = dateString //as! String

            
            descriptionLabel.text = job["bio"] as? String ?? ""
            
            let pay = job["pay"] as? String
            costLabel.text = "$" + pay!
            
            let skills = job["tags"] as! [String]
            for skill in skills {
                skillsLabel.text = skill + ", "
            }
            
        }
    }
    
    @IBOutlet weak var jobPostImageView: UIImageView!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var dificultyLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var datePostedLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var skillsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

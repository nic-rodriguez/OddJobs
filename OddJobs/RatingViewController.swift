//
//  RatingViewController.swift
//  OddJobs
//
//  Created by Nicolas Rodriguez on 7/25/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class RatingViewController: UIViewController {

    @IBOutlet weak var oneStar: UIButton!
    @IBOutlet weak var twoStar: UIButton!
    @IBOutlet weak var threeStar: UIButton!
    @IBOutlet weak var fourStar: UIButton!
    @IBOutlet weak var fiveStar: UIButton!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var userImageView: PFImageView!
    @IBOutlet weak var commentsTextField: UITextField!
    
    var user: PFUser!
    var job: PFObject! {
        didSet {
            user = job["userPosted"] as? PFUser
            userImageView.file = user["profilePicture"] as? PFFile
            userImageView.loadInBackground()
            jobLabel.text = job["title"] as? String
        }
    }
    var ratingSelected = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func donePress(_ sender: Any) {
        var comments = user["comments"] as? [String]
        var rating = user["rating"] as? [Int]
        
        if rating == nil {
            rating = []
        }
        if comments == nil {
            comments = []
        }
        
        if let comment = commentsTextField.text {
            comments!.append(comment)
            user["comments"] = comments!
        }
        
        if fiveStar.isSelected {
            rating!.append(5)
        } else if fourStar.isSelected {
            rating!.append(4)
        } else if threeStar.isSelected {
            rating!.append(3)
        } else if twoStar.isSelected {
            rating!.append(2)
        } else if oneStar.isSelected {
            rating!.append(1)
        } else {
            //raise alert controller: please select a rating
            ratingSelected = false
        }
        if ratingSelected {
            user["rating"] = rating
            user.saveInBackground()
            dismiss(animated: true, completion: nil)
        }
    }
}

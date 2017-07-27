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
    
    var user: PFUser! {
        didSet {
        }
    }
    var job: PFObject! {
        didSet {
            print(job)
            print(job["title"])
        }
    }
    var ratingSelected = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jobLabel.text = job["title"] as? String
        fetchUserData()
    }
    
    func fetchUserData() {
        let query = PFQuery(className: "_User")
        query.includeKey("jobsInterested")
        query.includeKey("_p_userPosted")
        query.includeKey("_User")
        query.includeKey("username")
        
        
        query.getObjectInBackground(withId: user.objectId!) { (user: PFObject?, error:Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.user = user as! PFUser
                self.userImageView.file = self.user["profilePicture"] as? PFFile
                self.userLabel.text = self.user["username"] as? String
                self.userImageView.loadInBackground()

            }
        }
    }
    
    @IBAction func fivePress(_ sender: Any) {
        fiveStar.isSelected = true
        fourStar.isSelected = true
        threeStar.isSelected = true
        twoStar.isSelected = true
        oneStar.isSelected = true
        ratingSelected = true
    }
    
    @IBAction func fourPress(_ sender: Any) {
        fourStar.isSelected = true
        threeStar.isSelected = true
        twoStar.isSelected = true
        oneStar.isSelected = true
        ratingSelected = true
    }
    
    @IBAction func threePress(_ sender: Any) {
        threeStar.isSelected = true
        twoStar.isSelected = true
        oneStar.isSelected = true
        ratingSelected = true
    }
    
    @IBAction func twoPress(_ sender: Any) {
        twoStar.isSelected = true
        oneStar.isSelected = true
        ratingSelected = true
    }
    
    @IBAction func onePress(_ sender: Any) {
        oneStar.isSelected = true
        ratingSelected = true
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
            let alertController = UIAlertController(title: "No rating selected", message: "Please select a rating", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                print("User dismissed error")
            })
            alertController.addAction(okAction)
            present(alertController, animated: true)
            ratingSelected = false
        }
        if ratingSelected {
            user["rating"] = rating
            user.saveInBackground()
            dismiss(animated: true, completion: nil)
        }
    }
}

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
    @IBOutlet weak var backgroundCardView: UIView!
    
    var user: PFUser!
    var job: PFObject!
    var rating = 0
    var ratingSelected = false
    var color = ColorObject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jobLabel.text = job["title"] as? String
        fetchUserData()
        
        view.backgroundColor = color.myTealColor
        
        configureButtonColors()
        buttonSetUp(oneStar)
        buttonSetUp(twoStar)
        buttonSetUp(threeStar)
        buttonSetUp(fourStar)
        buttonSetUp(fiveStar)
        
        backgroundCardView.backgroundColor = color.myLightColor
        backgroundCardView.layer.cornerRadius = 3.0
        backgroundCardView.layer.masksToBounds = false
        backgroundCardView.layer.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5).cgColor
        backgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundCardView.layer.shadowOpacity = 0.4
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
    
    func buttonSetUp(_ sender:UIButton) {
        sender.setTitleColor(color.myTealColor, for: .selected)
        sender.setTitleColor(color.myLightColor, for: .normal)
        
        sender.layer.cornerRadius = 5.0
        sender.layer.masksToBounds = false
//        sender.layer.shadowColor = color.myRedColor.cgColor
//        sender.layer.shadowOpacity = 0.8
        sender.layer.borderWidth = 2
        sender.layer.borderColor = color.myLightColor.cgColor
    }
    
    func configureButtonColors() {
        if (fiveStar.isSelected) {
            fiveStar.backgroundColor = color.myLightColor
            
        } else {
            fiveStar.backgroundColor = color.myTealColor
        }
        
        if (fourStar.isSelected) {
            fourStar.backgroundColor = color.myLightColor
        } else {
            fourStar.backgroundColor = color.myTealColor
        }
        
        if (threeStar.isSelected) {
            threeStar.backgroundColor = color.myLightColor
        } else {
            threeStar.backgroundColor = color.myTealColor
        }
        
        if (twoStar.isSelected) {
            twoStar.backgroundColor = color.myLightColor
        } else {
            twoStar.backgroundColor = color.myTealColor
        }
        
        if (oneStar.isSelected) {
            oneStar.backgroundColor = color.myLightColor
        } else {
            oneStar.backgroundColor = color.myTealColor
        }
    }
    
    @IBAction func fivePress(_ sender: Any) {
        rating = 5
        fiveStar.isSelected = true
        fourStar.isSelected = true
        threeStar.isSelected = true
        twoStar.isSelected = true
        oneStar.isSelected = true
        ratingSelected = true
        configureButtonColors()
    }
    
    @IBAction func fourPress(_ sender: Any) {
        rating = 4
        fiveStar.isSelected = false
        fourStar.isSelected = true
        threeStar.isSelected = true
        twoStar.isSelected = true
        oneStar.isSelected = true
        ratingSelected = true
        configureButtonColors()
    }
    
    @IBAction func threePress(_ sender: Any) {
        rating = 3
        fiveStar.isSelected = false
        fourStar.isSelected = false
        threeStar.isSelected = true
        twoStar.isSelected = true
        oneStar.isSelected = true
        ratingSelected = true
        configureButtonColors()
    }
    
    @IBAction func twoPress(_ sender: Any) {
        rating = 2
        fiveStar.isSelected = false
        fourStar.isSelected = false
        threeStar.isSelected = false
        twoStar.isSelected = true
        oneStar.isSelected = true
        ratingSelected = true
        configureButtonColors()
    }
    
    @IBAction func onePress(_ sender: Any) {
        rating = 1
        fiveStar.isSelected = false
        fourStar.isSelected = false
        threeStar.isSelected = false
        twoStar.isSelected = false
        oneStar.isSelected = true
        ratingSelected = true
        configureButtonColors()
    }
    
    @IBAction func donePress(_ sender: Any) {
        if ratingSelected {
            Rating.rateUser(userId: user.objectId!, starRating: rating, message: commentsTextField.text, completion: { (success: Bool, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("rating created")
                    self.dismiss(animated: true, completion: nil)
                }
            })
        } else {
            let alertController = UIAlertController(title: "No rating selected", message: "Please select a rating", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                print("User dismissed error")
            })
            alertController.addAction(okAction)
            present(alertController, animated: true)
        }
    }
}

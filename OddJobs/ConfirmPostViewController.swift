//
//  ConfirmPostViewController.swift
//  OddJobs
//
//  Created by Pavani Malli on 7/28/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import GooglePlacePicker
import Parse
import ParseUI

class ConfirmPostViewController: UIViewController {

    @IBOutlet var totalView: UIView!
    @IBOutlet weak var backgroundCardView: UIView!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var payLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationTimeLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var profileImageView: PFImageView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var descriptionBackgroundView: UIView!
    var jobDate: Date!
    var tags: [String] = []
    var address: CLLocationCoordinate2D?
    var formattedAddress: String!
    var jobTitle: String = ""
    var jobDescription: String = ""
    var pay: Double = 0
    var currentDate: Date! = Date()
    
    let color = ColorObject()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImageView.backgroundColor = color.myTealColor

        
        let currentUser = PFUser.current()
        profileImageView.file = currentUser?["profilePicture"] as? PFFile
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        profileImageView.layer.masksToBounds = true
        profileImageView.loadInBackground()
        
        backgroundCardView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        self.backgroundCardView.layer.cornerRadius = 3.0
        self.backgroundCardView.layer.masksToBounds = false
        self.backgroundCardView.layer.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5).cgColor
        self.backgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.backgroundCardView.layer.shadowOpacity = 0.8


        jobTitleLabel.text = jobTitle
        
        descriptionBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.04)
        print(jobDescription)
        descriptionLabel.text = jobDescription
        
        let payString = String(format:"%.2f", pay)
        payLabel.text = "$" + payString
        
        locationTimeLabel.text =  formattedAddress
  
        
        tagsLabel.text = ""
        for (index, element) in tags.enumerated() {
            tagsLabel.text = tagsLabel.text! + element
            if (index < tags.count - 1) {
                tagsLabel.text = tagsLabel.text! + ", "
            }
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func postJob(_ sender: UIBarButtonItem) {
        Job.postJob(location: address!, address: formattedAddress, title: jobTitle, description: jobDescription, datePosted: currentDate, dateDue: jobDate, tags: self.tags, pay: pay , completion: { (success, error) in
            if success {
                print("Post was saved!")
                let alert = UIAlertController(title: "Posted!", message: "Your job is offically posted! Look out for notifications from potential workers", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.dismiss(animated: true, completion: {
                    
                })
                
                
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        })
    }

   
}




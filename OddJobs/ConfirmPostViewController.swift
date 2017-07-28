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

class ConfirmPostViewController: UIViewController {

    
    var jobDate: Date!
    var tags: [String] = []
    var address: CLLocationCoordinate2D?
    var jobTitle: String = ""
    var jobDescription: String = ""
    var pay: Double = 0
    var currentDate: Date!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   /* @IBAction func postJob(_ sender: UIButton) {
        jobTitle = jobTitleField.text!
        jobDescription = jobDescriptionField.text!
        
        pay = Double(payField.text!) ?? 0
        jobDate = jobDatePicker.date
        currentDate = Date()
        photoToPost = jobImageView.image
        
        if (pay != nil) && (jobDate != nil) && (currentDate != nil) && (photoToPost != nil) {
            Job.postJob(location: address!, title: jobTitle, description: jobDescription, datePosted: currentDate, dateDue: jobDate, tags: self.tags, difficulty: 0, pay: pay, image: photoToPost , completion: { (success, error) in
                if success {
                    print("Post was saved!")
                    
                } else if let error = error {
                    print("Problem saving message: \(error.localizedDescription)")
                }
            })
        } else {
            print("user tried to post an empty job")
            let alert = UIAlertController(title: "Error", message: "Some or all of the required fields are incomplete. Please fill in the missing information.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }*/
}



